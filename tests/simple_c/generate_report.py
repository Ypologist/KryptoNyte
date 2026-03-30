#!/usr/bin/env python3
import argparse
import html
import os
from datetime import datetime

def read_lines(path):
    if not path or not os.path.exists(path):
        return []
    with open(path, "r", encoding="utf-8") as f:
        return [line.strip() for line in f.readlines()]


def render_table(expected, actual):
    rows = []
    max_len = max(len(expected), len(actual))
    for i in range(max_len):
        exp = expected[i] if i < len(expected) else ""
        act = actual[i] if i < len(actual) else ""
        ok = (exp == act) and exp != ""
        rows.append((i, exp, act, ok))
    return rows


def main():
    parser = argparse.ArgumentParser(description="Generate HTML report for simple C signature test")
    parser.add_argument("--expected", required=True, help="Path to expected.signature")
    parser.add_argument("--actual", required=True, help="Path to actual signature")
    parser.add_argument("--log", default="", help="Path to simulator log")
    parser.add_argument("--out", required=True, help="Output HTML path")
    args = parser.parse_args()

    expected = read_lines(args.expected)
    actual = read_lines(args.actual)
    rows = render_table(expected, actual)

    total = len(rows)
    passed = sum(1 for _, _, _, ok in rows if ok)
    failed = total - passed
    status = "PASS" if failed == 0 and total > 0 else "FAIL"

    log_lines = read_lines(args.log)
    log_tail = log_lines[-50:] if log_lines else []

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def esc(s):
        return html.escape(s, quote=True)

    with open(args.out, "w", encoding="utf-8") as f:
        f.write("<!doctype html>\n")
        f.write("<html lang=\"en\">\n<head>\n")
        f.write("<meta charset=\"utf-8\">\n")
        f.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n")
        f.write("<title>Simple C Signature Report</title>\n")
        f.write("<style>\n")
        f.write("body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;"
                "margin:24px;background:#f7f7f9;color:#111;}\n")
        f.write(".card{background:#fff;border:1px solid #e3e3e8;border-radius:8px;padding:16px;margin-bottom:16px;}\n")
        f.write(".status{font-weight:700;}\n")
        f.write(".pass{color:#0a7a3d;} .fail{color:#b00020;}\n")
        f.write("table{border-collapse:collapse;width:100%;} th,td{border:1px solid #e3e3e8;"
                "padding:6px 8px;text-align:left;font-family:ui-monospace,Menlo,Monaco,Consolas,'Liberation Mono','Courier New',monospace;}\n")
        f.write("tr.ok{background:#eafff1;} tr.bad{background:#ffecec;}\n")
        f.write(".meta{color:#444;font-size:0.9em;}\n")
        f.write("pre{white-space:pre-wrap;background:#111;color:#eee;padding:12px;border-radius:6px;}\n")
        f.write("</style>\n</head>\n<body>\n")

        f.write("<div class=\"card\">\n")
        f.write(f"<div class=\"status {('pass' if status=='PASS' else 'fail')}\">{status}</div>\n")
        f.write(f"<div class=\"meta\">Generated: {esc(timestamp)}</div>\n")
        f.write(f"<div class=\"meta\">Expected: {esc(args.expected)}</div>\n")
        f.write(f"<div class=\"meta\">Actual: {esc(args.actual)}</div>\n")
        if args.log:
            f.write(f"<div class=\"meta\">Log: {esc(args.log)}</div>\n")
        f.write(f"<div class=\"meta\">Rows: {total}, Passed: {passed}, Failed: {failed}</div>\n")
        f.write("</div>\n")

        f.write("<div class=\"card\">\n")
        f.write("<h2>Signature Diff</h2>\n")
        f.write("<table>\n")
        f.write("<tr><th>Index</th><th>Expected</th><th>Actual</th><th>Match</th></tr>\n")
        for idx, exp, act, ok in rows:
            cls = "ok" if ok else "bad"
            f.write(f"<tr class=\"{cls}\">")
            f.write(f"<td>{idx}</td><td>{esc(exp)}</td><td>{esc(act)}</td><td>{'OK' if ok else 'BAD'}</td>")
            f.write("</tr>\n")
        f.write("</table>\n</div>\n")

        f.write("<div class=\"card\">\n")
        f.write("<h2>Simulator Log (tail)</h2>\n")
        if log_tail:
            f.write("<pre>\n")
            f.write("\n".join(esc(line) for line in log_tail))
            f.write("\n</pre>\n")
        else:
            f.write("<div class=\"meta\">No log data available.</div>\n")
        f.write("</div>\n")

        f.write("</body>\n</html>\n")


if __name__ == "__main__":
    main()
