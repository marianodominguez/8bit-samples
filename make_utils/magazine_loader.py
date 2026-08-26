import json
import re
from pathlib import Path
from urllib import request
from urllib.parse import quote, urljoin


def _read_text_from_url_or_file(source: str | Path) -> str:
    source_text = str(source)
    source_path = Path(source_text)
    if source_path.exists():
        return source_path.read_text(encoding="utf-8", errors="ignore")

    if not source_text.startswith(("http://", "https://")):
        return ""

    try:
        req = request.Request(source_text, headers={"User-Agent": "Mozilla/5.0"})
        with request.urlopen(req, timeout=30) as response:
            return response.read().decode("utf-8", "ignore")
    except Exception as exc:  # pragma: no cover - network issues are handled at runtime
        print(f"SKIP unreadable page: {source} ({exc})")
        return ""


def _extract_year_from_identifier(identifier: str) -> int | None:
    """Best-effort year extraction for identifiers like compute_0003_mar-apr80 or 1994 issue names."""
    if not identifier:
        return None

    match = re.search(r'(19\d{2}|20\d{2})', identifier)
    if match:
        return int(match.group(1))

    years = re.findall(r'\b(\d{2})\b', identifier)
    if not years:
        return None

    short_year = int(years[-1])
    return 1900 + short_year if short_year >= 50 else 2000 + short_year


def _load_issue_links_from_api(max_year: int | None = None) -> list[str]:
    """Use the Archive advanced-search API with pagination to fetch issue identifiers."""
    query = 'collection:"compute-magazine"'
    issue_urls: set[str] = set()
    page = 1

    while True:
        api_url = (
            'https://archive.org/advancedsearch.php'
            f'?q={quote(query)}'
            '&fl[]=identifier'
            '&sort[]=addeddate+desc'
            '&rows=1000'
            f'&page={page}'
            '&output=json'
        )

        try:
            req = request.Request(api_url, headers={"User-Agent": "Mozilla/5.0"})
            with request.urlopen(req, timeout=60) as response:
                payload = json.loads(response.read().decode('utf-8', 'ignore'))
        except Exception as exc:
            print(f"SKIP failed API page {page}: {exc}")
            break

        docs = payload.get('response', {}).get('docs', [])
        if not docs:
            break

        for doc in docs:
            identifier = doc.get('identifier', '').strip()
            if not identifier:
                continue
            year = _extract_year_from_identifier(identifier)
            if max_year is not None and year is not None and year > max_year:
                continue
            issue_urls.add(f'https://archive.org/details/{identifier}')

        if len(docs) < 1000:
            break
        page += 1

    return sorted(issue_urls)


def load_issue_links(index_page: str | Path, max_year: int | None = None) -> list[str]:
    """Return issue detail URLs from a saved HTML page or paginated Archive API data."""
    index_value = str(index_page)
    if index_value.startswith('http'):
        return _load_issue_links_from_api(max_year=max_year)

    file_path = Path(index_value)
    if not file_path.exists():
        return _load_issue_links_from_api(max_year=max_year)

    html = _read_text_from_url_or_file(index_page)
    matches = re.findall(
        r'https?://archive\.org/details/[^"\'\s>]*compute-magazine[^"\'\s>]*',
        html,
        re.I,
    )
    issue_urls = []
    for issue_url in sorted(set(matches)):
        if max_year is None:
            issue_urls.append(issue_url)
            continue
        issue_id = issue_url.rstrip('/').split('/')[-1]
        year = _extract_year_from_identifier(issue_id)
        if year is None or year <= max_year:
            issue_urls.append(issue_url)
    return issue_urls


def load_issue_pdf_links(issue_url: str) -> list[str]:
    """Return the actual PDF file URLs from an issue detail page."""
    html = _read_text_from_url_or_file(issue_url)
    if not html:
        return []

    matches = re.findall(
        r'(?:https?://archive\.org)?/download/[^"\'\s>]+\.pdf(?:\?[^"\'\s>]*)?',
        html,
        re.I,
    )
    urls = []
    for match in matches:
        if "torrent" in match.lower() or match.lower().endswith(".pdf") is False:
            continue
        urls.append(urljoin(issue_url, match))
    return sorted(set(urls))


def download_magazines(index_page: str | Path, destination_folder: str = "/home/BACKUP/Compute_magazine", max_year: int | None = 1990) -> int:
    """Download issue PDFs from the saved archive page, skipping files already saved."""
    destination = Path(destination_folder)
    destination.mkdir(parents=True, exist_ok=True)

    downloaded = 0
    seen = set()

    for issue_url in load_issue_links(index_page, max_year=max_year):
        for pdf_url in load_issue_pdf_links(issue_url):
            if pdf_url in seen:
                continue
            seen.add(pdf_url)

            filename = Path(pdf_url.split("?", 1)[0]).name
            target = destination / filename

            if target.exists():
                print(f"SKIP already downloaded: {filename}")
                continue

            try:
                req = request.Request(pdf_url, headers={"User-Agent": "Mozilla/5.0"})
                with request.urlopen(req, timeout=120) as response, open(target, "wb") as outfile:
                    while True:
                        chunk = response.read(1024 * 1024)
                        if not chunk:
                            break
                        outfile.write(chunk)
            except Exception as exc:
                print(f"SKIP failed download: {filename} ({exc})")
                continue

            downloaded += 1
            print(f"DOWNLOADED {filename}")

    return downloaded


if __name__ == "__main__":
    local_archive = Path(__file__).with_name("MagazineArchive.html")
    MAGAZINE_INDEX = str(local_archive) if local_archive.exists() else "https://archive.org/details/compute-magazine"
    print(f"Downloaded {download_magazines(MAGAZINE_INDEX, max_year=1990)} files.")

