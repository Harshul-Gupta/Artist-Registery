<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored= "false"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Artist Profile</title>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Bebas+Neue&family=DM+Mono:wght@300;400&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg: #0a0a0a;
      --surface: #111111;
      --border: #1e1e1e;
      --text: #e8e2d9;
      --muted: #5a5550;
      --accent: #c9a96e;
      --accent-dim: rgba(201, 169, 110, 0.12);
      --accent-glow: rgba(201, 169, 110, 0.25);
    }

    html, body {
      height: 100%;
      background: var(--bg);
      color: var(--text);
      font-family: 'Cormorant Garamond', serif;
      overflow-x: hidden;
    }

    /* Grain overlay */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");
      pointer-events: none;
      z-index: 9999;
      opacity: 0.4;
    }

    /* Radial ambient glow */
    .bg-glow {
      position: fixed;
      top: -20%;
      left: 50%;
      transform: translateX(-50%);
      width: 80vw;
      height: 60vh;
      background: radial-gradient(ellipse at center, rgba(201,169,110,0.055) 0%, transparent 70%);
      pointer-events: none;
      z-index: 0;
    }

    /* ─── Layout ─── */
    .page {
      position: relative;
      z-index: 1;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 4rem 2rem;
    }

    /* ─── Top bar ─── */
    .top-bar {
      position: fixed;
      top: 0; left: 0; right: 0;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1.4rem 3rem;
      border-bottom: 1px solid var(--border);
      background: rgba(10,10,10,0.85);
      backdrop-filter: blur(14px);
      z-index: 100;
      animation: slideDown 0.6s ease forwards;
    }

    .top-bar .logo {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 1.1rem;
      letter-spacing: 0.35em;
      color: var(--accent);
      opacity: 0.9;
    }

    .top-bar .badge {
      font-family: 'DM Mono', monospace;
      font-size: 0.65rem;
      letter-spacing: 0.2em;
      color: var(--muted);
      text-transform: uppercase;
    }

    /* ─── Card ─── */
    .card {
      position: relative;
      max-width: 720px;
      width: 100%;
      background: var(--surface);
      border: 1px solid var(--border);
      overflow: hidden;
      opacity: 0;
      transform: translateY(28px);
      animation: riseIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) 0.3s forwards;
    }

    /* Diagonal accent line */
    .card::before {
      content: '';
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 3px;
      background: linear-gradient(90deg, transparent 0%, var(--accent) 50%, transparent 100%);
    }

    /* ─── Card header ─── */
    .card-header {
      display: flex;
      align-items: flex-end;
      gap: 2.5rem;
      padding: 2.8rem 3rem 2.2rem;
      border-bottom: 1px solid var(--border);
      position: relative;
    }

    .avatar {
      flex-shrink: 0;
      width: 88px;
      height: 88px;
      border-radius: 0;
      background: var(--accent-dim);
      border: 1px solid var(--accent);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Bebas Neue', sans-serif;
      font-size: 2.8rem;
      color: var(--accent);
      letter-spacing: 0.05em;
      position: relative;
      overflow: hidden;
    }

    .avatar::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, transparent 60%, rgba(201,169,110,0.15) 100%);
    }

    .header-text {
      flex: 1;
    }

    .artist-label {
      font-family: 'DM Mono', monospace;
      font-size: 0.62rem;
      letter-spacing: 0.3em;
      color: var(--accent);
      text-transform: uppercase;
      margin-bottom: 0.5rem;
      opacity: 0;
      animation: fadeUp 0.5s ease 0.7s forwards;
    }

    .artist-name {
      font-size: clamp(2rem, 5vw, 3rem);
      font-weight: 300;
      line-height: 1;
      letter-spacing: -0.01em;
      color: var(--text);
      opacity: 0;
      animation: fadeUp 0.6s ease 0.85s forwards;
    }

    .artist-name em {
      font-style: italic;
      color: var(--accent);
    }

    /* ─── Card body ─── */
    .card-body {
      padding: 2.2rem 3rem;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1.6rem 3rem;
    }

    .meta-item {
      opacity: 0;
      animation: fadeUp 0.5s ease var(--delay, 1s) forwards;
    }

    .meta-label {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem;
      letter-spacing: 0.25em;
      color: var(--muted);
      text-transform: uppercase;
      margin-bottom: 0.4rem;
    }

    .meta-value {
      font-size: 1.05rem;
      font-weight: 300;
      color: var(--text);
      letter-spacing: 0.02em;
    }

    .meta-value.highlight {
      color: var(--accent);
      font-size: 1.25rem;
    }

    /* ─── Divider with text ─── */
    .divider {
      margin: 0 3rem;
      border: none;
      border-top: 1px solid var(--border);
      position: relative;
    }

    .divider::after {
      content: '✦';
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      background: var(--surface);
      padding: 0 0.8rem;
      color: var(--muted);
      font-size: 0.6rem;
    }

    /* ─── Footer row ─── */
    .card-footer {
      padding: 1.4rem 3rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: rgba(255,255,255,0.015);
      border-top: 1px solid var(--border);
      opacity: 0;
      animation: fadeUp 0.5s ease 1.3s forwards;
    }

    .id-chip {
      font-family: 'DM Mono', monospace;
      font-size: 0.65rem;
      letter-spacing: 0.18em;
      color: var(--muted);
    }

    .id-chip span {
      color: var(--accent);
      opacity: 0.7;
    }

    .status-dot {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.62rem;
      letter-spacing: 0.15em;
      color: var(--muted);
      text-transform: uppercase;
    }

    .dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      background: #4caf82;
      box-shadow: 0 0 8px #4caf82;
      animation: pulse 2s ease-in-out infinite;
    }

    /* ─── Corner decorations ─── */
    .corner {
      position: absolute;
      width: 14px; height: 14px;
      border-color: var(--accent);
      border-style: solid;
      opacity: 0.4;
    }
    .corner.tl { top: 8px; left: 8px; border-width: 1px 0 0 1px; }
    .corner.tr { top: 8px; right: 8px; border-width: 1px 1px 0 0; }
    .corner.bl { bottom: 8px; left: 8px; border-width: 0 0 1px 1px; }
    .corner.br { bottom: 8px; right: 8px; border-width: 0 1px 1px 0; }

    /* ─── Animations ─── */
    @keyframes slideDown {
      from { transform: translateY(-100%); opacity: 0; }
      to   { transform: translateY(0);    opacity: 1; }
    }

    @keyframes riseIn {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(10px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50%       { opacity: 0.4; }
    }

    /* ─── Responsive ─── */
    @media (max-width: 540px) {
      .top-bar { padding: 1.2rem 1.5rem; }
      .card-header { padding: 2rem 1.6rem 1.6rem; gap: 1.5rem; }
      .card-body { padding: 1.6rem; grid-template-columns: 1fr; gap: 1.2rem; }
      .card-footer { padding: 1.2rem 1.6rem; }
      .divider { margin: 0 1.6rem; }
      .artist-name { font-size: 1.9rem; }
    }
  </style>
</head>
<body>

<div class="bg-glow"></div>

<nav class="top-bar">
  <span class="logo">Artistica</span>
  <span class="badge">Artist Registry</span>
</nav>

<main class="page">
  <div class="card">
    <!-- Corner decorations -->
    <div class="corner tl"></div>
    <div class="corner tr"></div>
    <div class="corner bl"></div>
    <div class="corner br"></div>

    <!-- Header -->
    <div class="card-header">
      <div class="avatar" id="avatar">—</div>
      <div class="header-text">
        <p class="artist-label">Artist Profile</p>
        <h1 class="artist-name" id="artist-display">Loading…</h1>
      </div>
    </div>

    <!-- Meta grid -->
    <div class="card-body">
      <div class="meta-item" style="--delay: 1.0s">
        <p class="meta-label">Full Name</p>
        <p class="meta-value" id="meta-name">—</p>
      </div>
      <div class="meta-item" style="--delay: 1.1s">
        <p class="meta-label">Artist ID</p>
        <p class="meta-value highlight" id="meta-id">—</p>
      </div>
      <div class="meta-item" style="--delay: 1.15s">
        <p class="meta-label">Genre</p>
        <p class="meta-value" id="meta-genre">—</p>
      </div>
      <div class="meta-item" style="--delay: 1.2s">
        <p class="meta-label">Origin</p>
        <p class="meta-value" id="meta-origin">—</p>
      </div>
    </div>

    <hr class="divider" />

    <!-- Footer -->
    <div class="card-footer">
      <span class="id-chip">ref / <span id="footer-id">—</span></span>
      <span class="status-dot"><span class="dot"></span>Active</span>
    </div>
  </div>
</main>

<script>
  // ─── Artist data from JSP EL ───────────────────────────────────
  var artistId   = "${artist.id}";
  var artistName = "${artist.name}";

  // ─── Helpers ───────────────────────────────────────────────────
  function initials(name) {
    return name
      .split(' ')
      .map(w => w[0])
      .slice(0, 2)
      .join('')
      .toUpperCase();
  }

  // ─── Render ─────────────────────────────────────────────────────
  function render(id, name) {
    const parts       = name.trim().split(' ');
    const first       = parts[0];
    const rest        = parts.slice(1).join(' ');
    const formattedId = 'ART-' + String(id).padStart(6, '0');

    // Big name — italicise the first word for elegance
    document.getElementById('artist-display').innerHTML =
    	'<em>' + first + '</em>' + (rest ? ' ' + rest : '');

    document.getElementById('avatar').textContent    = initials(name);
    document.getElementById('meta-name').textContent = name;
    document.getElementById('meta-id').textContent   = formattedId;
    document.getElementById('footer-id').textContent = formattedId;

    // Update tab title
    document.title = name + ' — Artistica';
  }

  render(artistId, artistName);
</script>

</body>
</html>