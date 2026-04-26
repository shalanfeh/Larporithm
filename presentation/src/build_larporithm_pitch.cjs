const fs = require("fs");
const path = require("path");
const sharp = require("sharp");
const PptxGenJS = require("pptxgenjs");

const ROOT = process.cwd();
const OUT_DIR = path.join(ROOT, "presentation", "output");
const PREVIEW_DIR = path.join(ROOT, "presentation", "previews");
const OUT = path.join(OUT_DIR, "Larporithm_Demo_Deck.pptx");

fs.mkdirSync(OUT_DIR, { recursive: true });
fs.mkdirSync(PREVIEW_DIR, { recursive: true });

const pptx = new PptxGenJS();
pptx.layout = "LAYOUT_WIDE";
pptx.author = "Larporithm Team";
pptx.subject = "Hackathon demo pitch";
pptx.title = "Larporithm Demo";
pptx.company = "Larporithm";
pptx.lang = "en-US";
pptx.theme = {
  headFontFace: "Aptos Display",
  bodyFontFace: "Aptos",
  lang: "en-US",
};

const C = {
  bg: "111611",
  gridA: "171D18",
  gridB: "202720",
  ink: "F8FFF2",
  muted: "C8D8CC",
  green: "75FF3D",
  lime: "B7FF5B",
  amber: "FFCC67",
  red: "FF695F",
  cyan: "7FE3FF",
  panel: "253027",
};

const slides = [
  {
    title: "Larporithm",
    subtitle: "You are the recommendation algorithm.",
    body: "Learn a viewer's hidden likes and dislikes from mood, time, and analytics.",
    tag: "Hackathon demo",
    notes: [
      "Hi, we built Larporithm.",
      "Instead of being the person watching videos, you play as the recommendation algorithm.",
      "Your goal is to infer hidden likes and dislikes from the viewer's reactions.",
    ],
  },
  {
    title: "The problem",
    subtitle: "Algorithms start by guessing.",
    body: "Recommend. Watch the reaction. Update the guess. Repeat. That feedback loop is powerful, but it can also narrow what people see.",
    tag: "Guess -> React -> Learn",
    notes: [
      "Recommendation systems do not know you at first.",
      "They learn from feedback: clicks, watch time, skips, and other signals.",
      "Our game makes that hidden loop visible and playable.",
    ],
  },
  {
    title: "The game loop",
    subtitle: "The viewer has hidden tastes.",
    body: "The player enters a video title. AI scores its categories. Likes lift mood and time. Dislikes drop mood and time. Analytics becomes the algorithm's learned guess.",
    tag: "Hidden likes + hidden dislikes",
    notes: [
      "The viewer secretly likes some categories and dislikes others.",
      "The player only sees the reaction: mood, timer, and analytics movement.",
      "That is how the algorithm learns.",
    ],
  },
  {
    title: "How to win the demo",
    subtitle: "Treat every reaction like evidence.",
    body: "Start broad. If mood improves, test nearby categories. If mood drops, avoid that signal and try a different direction. The goal is to make analytics match the viewer's hidden tastes.",
    tag: "Infer, don't memorize",
    notes: [
      "During the live demo, I will start with broad titles.",
      "When the viewer reacts well, I will double down.",
      "When mood drops, I will treat that as evidence of a dislike.",
    ],
  },
  {
    title: "Why it is demo-ready",
    subtitle: "The loop survives real presentation conditions.",
    body: "Search button and Enter both work. The face is centered. Mood labels explain feedback. Offline fallback scoring keeps the game moving if the API fails.",
    tag: "Built for the stage",
    notes: [
      "We fixed the demo path so the game does not freeze if the API fails.",
      "The mood label makes the feedback readable to judges watching from a distance.",
      "The end screen reveals the hidden truth and the algorithm's best guesses.",
    ],
  },
  {
    title: "The takeaway",
    subtitle: "Recommendation systems are not neutral lists.",
    body: "They learn from behavior, optimize toward feedback, and shape the experience. Larporithm lets players feel that pressure in under five minutes.",
    tag: "Playable explanation",
    notes: [
      "The takeaway is simple.",
      "Recommendation systems learn from reactions, then steer future recommendations.",
      "Larporithm turns that invisible process into a quick, understandable game.",
    ],
  },
];

function addGrid(slide) {
  slide.background = { color: C.bg };
  for (let x = 0; x < 14; x++) {
    for (let y = 0; y < 8; y++) {
      slide.addShape(pptx.ShapeType.rect, {
        x: x * 0.98,
        y: y * 0.96,
        w: 0.94,
        h: 0.92,
        fill: { color: (x + y) % 2 === 0 ? C.gridA : C.gridB },
        line: { color: (x + y) % 2 === 0 ? C.gridA : C.gridB },
      });
    }
  }
}

function addPill(slide, text, x, y, w, color) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x,
    y,
    w,
    h: 0.46,
    rectRadius: 0.08,
    fill: { color },
    line: { color },
    transparency: 8,
  });
  slide.addText(text, {
    x,
    y: y + 0.08,
    w,
    h: 0.28,
    align: "center",
    fontFace: "Aptos",
    fontSize: 15,
    bold: true,
    color: C.bg,
    margin: 0,
    fit: "shrink",
  });
}

function addFace(slide, idx) {
  const face = idx === 0 ? "VeryHappyR.png" : idx === 5 ? "HappyR.png" : "NeutralR.png";
  const facePath = path.join(ROOT, "assets", face);
  if (fs.existsSync(facePath)) {
    slide.addImage({ path: facePath, x: 9.1, y: 1.1, w: 2.65, h: 2.65, transparency: 3 });
  }
}

function addSlide(data, idx) {
  const slide = pptx.addSlide();
  addGrid(slide);
  slide.addShape(pptx.ShapeType.rect, {
    x: 0,
    y: 0,
    w: 13.333,
    h: 7.5,
    fill: { color: C.bg, transparency: 18 },
    line: { color: C.bg, transparency: 100 },
  });
  addPill(slide, data.tag, 0.78, 0.55, 2.8, idx === 4 ? C.amber : C.green);
  slide.addText(data.title, {
    x: 0.78,
    y: idx === 0 ? 1.35 : 1.05,
    w: idx === 0 ? 7.3 : 8.4,
    h: idx === 0 ? 1.15 : 0.78,
    fontFace: "Aptos Display",
    fontSize: idx === 0 ? 70 : 48,
    bold: true,
    color: idx === 0 ? C.green : C.ink,
    margin: 0,
    breakLine: false,
    fit: "shrink",
  });
  slide.addText(data.subtitle, {
    x: 0.82,
    y: idx === 0 ? 2.62 : 1.95,
    w: 7.8,
    h: 0.55,
    fontFace: "Aptos",
    fontSize: idx === 0 ? 25 : 24,
    bold: true,
    color: C.ink,
    margin: 0,
    fit: "shrink",
  });
  slide.addText(data.body, {
    x: 0.82,
    y: idx === 0 ? 3.38 : 2.75,
    w: 7.7,
    h: 1.75,
    fontFace: "Aptos",
    fontSize: 22,
    color: C.muted,
    margin: 0,
    breakLine: false,
    fit: "shrink",
  });
  addFace(slide, idx);
  slide.addShape(pptx.ShapeType.line, {
    x: 0.82,
    y: 6.56,
    w: 11.5,
    h: 0,
    line: { color: C.green, transparency: 35, width: 2 },
  });
  slide.addText("Larporithm demo pitch", {
    x: 0.82,
    y: 6.72,
    w: 3.4,
    h: 0.25,
    fontSize: 10,
    color: C.muted,
    margin: 0,
  });
  slide.addNotes(data.notes);
}

slides.forEach(addSlide);

function esc(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function svgFor(data, idx) {
  const bodyLines = wrapSvgLines(data.body, 54);
  const bodyY = idx === 0 ? 482 : 408;
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">
  <rect width="1920" height="1080" fill="#${C.bg}"/>
  ${Array.from({ length: 12 * 7 }, (_, i) => {
    const x = i % 12;
    const y = Math.floor(i / 12);
    return `<rect x="${x * 160}" y="${y * 154}" width="154" height="148" fill="#${(x + y) % 2 === 0 ? C.gridA : C.gridB}"/>`;
  }).join("")}
  <rect width="1920" height="1080" fill="#${C.bg}" opacity="0.22"/>
  <rect x="112" y="78" rx="22" width="410" height="66" fill="#${idx === 4 ? C.amber : C.green}"/>
  <text x="317" y="121" text-anchor="middle" font-family="Arial" font-size="28" font-weight="700" fill="#${C.bg}">${esc(data.tag)}</text>
  <text x="112" y="${idx === 0 ? 312 : 238}" font-family="Arial" font-size="${idx === 0 ? 118 : 78}" font-weight="800" fill="#${idx === 0 ? C.green : C.ink}">${esc(data.title)}</text>
  <text x="118" y="${idx === 0 ? 418 : 330}" font-family="Arial" font-size="${idx === 0 ? 42 : 40}" font-weight="700" fill="#${C.ink}">${esc(data.subtitle)}</text>
  ${bodyLines.map((line, i) => `<text x="118" y="${bodyY + i * 48}" font-family="Arial" font-size="36" fill="#${C.muted}">${esc(line)}</text>`).join("")}
  <circle cx="1505" cy="345" r="170" fill="#${idx === 5 ? C.green : idx === 4 ? C.amber : C.cyan}" opacity="0.22"/>
  <text x="1505" y="370" text-anchor="middle" font-family="Arial" font-size="54" font-weight="800" fill="#${C.ink}">MOOD</text>
  <line x1="118" y1="944" x2="1775" y2="944" stroke="#${C.green}" stroke-width="4" opacity="0.65"/>
  <text x="118" y="994" font-family="Arial" font-size="22" fill="#${C.muted}">Larporithm demo pitch</text>
</svg>`;
}

function wrapSvgLines(value, maxChars) {
  const words = value.split(/\s+/);
  const lines = [];
  let current = "";
  for (const word of words) {
    const next = current ? `${current} ${word}` : word;
    if (next.length > maxChars && current) {
      lines.push(current);
      current = word;
    } else {
      current = next;
    }
  }
  if (current) lines.push(current);
  return lines.slice(0, 5);
}

async function main() {
  await pptx.writeFile({ fileName: OUT });
  for (let i = 0; i < slides.length; i++) {
    const svg = svgFor(slides[i], i);
    await sharp(Buffer.from(svg)).png().toFile(path.join(PREVIEW_DIR, `slide-${String(i + 1).padStart(2, "0")}.png`));
  }
  console.log(OUT);
  console.log(PREVIEW_DIR);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
