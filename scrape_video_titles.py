import subprocess
import json

CATEGORIES = {
    "education": "education documentary",
    "political": "politics news debate",
    "gaming": "gaming gameplay",
    "music": "music video",
    "drama": "youtube drama",
    "sports": "sports highlights",
    "technology": "tech reviews",
    "health": "health wellness"
}

RESULTS_PER_CATEGORY = 50  # adjust as needed
OUTPUT_FILE = "video_titles.json"


def fetch_titles(query, limit):
    command = [
        "yt-dlp",
        f"ytsearch{limit}:{query}",
        "--print", "title",
        "--no-warnings",
        "--skip-download"
    ]

    result = subprocess.run(command, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"Error fetching {query}")
        return []

    titles = result.stdout.split("\n")
    return [t.strip() for t in titles if t.strip()]


def main():
    data = {}

    for category, query in CATEGORIES.items():
        print(f"Fetching: {category}")
        titles = fetch_titles(query, RESULTS_PER_CATEGORY)

        # Remove duplicates while preserving order
        seen = set()
        unique_titles = []
        for t in titles:
            if t not in seen:
                seen.add(t)
                unique_titles.append(t)

        data[category] = unique_titles

    # Save to JSON
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"\nSaved to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
