<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Artistica — Registry</title>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Bebas+Neue&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:           #0a0a0a;
      --surface:      #111111;
      --surface-2:    #141414;
      --border:       #1e1e1e;
      --border-hover: #2e2e2e;
      --text:         #e8e2d9;
      --muted:        #4a4540;
      --muted-2:      #6a6560;
      --accent:       #c9a96e;
      --accent-dim:   rgba(201, 169, 110, 0.10);
      --accent-glow:  rgba(201, 169, 110, 0.22);
      --danger:       #e07060;
    }

    html, body { height: 100%; background: var(--bg); color: var(--text); }

    /* Grain */
    body::before {
      content: '';
      position: fixed; inset: 0; pointer-events: none; z-index: 9999;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
      opacity: 0.45;
    }

    /* Ambient glow */
    .bg-glow {
      position: fixed; top: -10%; left: 50%; transform: translateX(-50%);
      width: 90vw; height: 55vh;
      background: radial-gradient(ellipse at center, rgba(201,169,110,0.05) 0%, transparent 68%);
      pointer-events: none; z-index: 0;
    }

    /* ─── Top bar ─── */
    .top-bar {
      position: fixed; top: 0; left: 0; right: 0; z-index: 200;
      display: flex; align-items: center; justify-content: space-between;
      padding: 1.3rem 3rem;
      border-bottom: 1px solid var(--border);
      background: rgba(10,10,10,0.88);
      backdrop-filter: blur(16px);
      animation: slideDown 0.6s ease forwards;
    }
    .logo {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 1.15rem; letter-spacing: 0.38em; color: var(--accent);
    }
    .nav-links {
      display: flex; gap: 2.4rem; list-style: none;
    }
    .nav-links a {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.22em;
      color: var(--muted-2); text-decoration: none; text-transform: uppercase;
      transition: color 0.2s;
    }
    .nav-links a:hover { color: var(--accent); }
    .nav-badge {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.2em;
      color: var(--muted); text-transform: uppercase;
    }

    /* ─── Page layout ─── */
    .page {
      position: relative; z-index: 1;
      min-height: 100vh;
      padding: 8rem 2rem 5rem;
      display: flex; flex-direction: column; align-items: center;
    }

    /* ─── Hero ─── */
    .hero {
      text-align: center;
      margin-bottom: 4.5rem;
      opacity: 0; animation: fadeUp 0.8s ease 0.3s forwards;
    }
    .hero-eyebrow {
      font-family: 'DM Mono', monospace;
      font-size: 0.62rem; letter-spacing: 0.35em;
      color: var(--accent); text-transform: uppercase;
      margin-bottom: 1rem;
    }
    .hero-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: clamp(3rem, 7vw, 5.5rem);
      font-weight: 300; line-height: 0.95;
      letter-spacing: -0.01em; color: var(--text);
      margin-bottom: 1.2rem;
    }
    .hero-title em { font-style: italic; color: var(--accent); }
    .hero-sub {
      font-family: 'DM Mono', monospace;
      font-size: 0.65rem; letter-spacing: 0.18em;
      color: var(--muted-2); text-transform: uppercase;
    }

    /* ─── Divider ─── */
    .section-divider {
      width: 100%; max-width: 900px;
      display: flex; align-items: center; gap: 1.5rem;
      margin-bottom: 3rem;
      opacity: 0; animation: fadeUp 0.6s ease 0.5s forwards;
    }
    .section-divider::before, .section-divider::after {
      content: ''; flex: 1; height: 1px; background: var(--border);
    }
    .section-divider span {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.3em;
      color: var(--muted); text-transform: uppercase; white-space: nowrap;
    }

    /* ─── Grid ─── */
    .grid {
      width: 100%; max-width: 900px;
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 1.5px;
      background: var(--border);
      border: 1px solid var(--border);
      opacity: 0; animation: riseIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) 0.6s forwards;
    }

    /* ─── Panel ─── */
    .panel {
      background: var(--surface);
      padding: 3rem 3rem 2.8rem;
      position: relative; overflow: hidden;
      transition: background 0.3s;
    }
    .panel:hover { background: var(--surface-2); }

    /* Top accent line */
    .panel::before {
      content: ''; position: absolute;
      top: 0; left: 0; right: 0; height: 2px;
      transition: opacity 0.3s; opacity: 0;
    }
    .panel.fetch::before  { background: linear-gradient(90deg, transparent, var(--accent), transparent); }
    .panel.update::before { background: linear-gradient(90deg, transparent, var(--danger), transparent); }
    .panel:hover::before  { opacity: 1; }

    /* Corner marks */
    .corner-mark {
      position: absolute; width: 12px; height: 12px;
      border-style: solid; border-color: var(--border);
      transition: border-color 0.3s;
    }
    .panel:hover .corner-mark { border-color: var(--accent); }
    .panel.update:hover .corner-mark { border-color: var(--danger); }
    .corner-mark.tl { top: 10px; left: 10px; border-width: 1px 0 0 1px; }
    .corner-mark.br { bottom: 10px; right: 10px; border-width: 0 1px 1px 0; }

    /* Panel header */
    .panel-tag {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.28em;
      text-transform: uppercase; margin-bottom: 0.5rem;
    }
    .panel.fetch  .panel-tag { color: var(--accent); }
    .panel.update .panel-tag { color: var(--danger); }

    .panel-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2rem; font-weight: 300;
      letter-spacing: -0.01em; line-height: 1;
      color: var(--text); margin-bottom: 0.5rem;
    }
    .panel-title em { font-style: italic; }
    .panel-desc {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.12em;
      color: var(--muted-2); text-transform: uppercase;
      margin-bottom: 2.4rem;
    }

    /* ─── Form elements ─── */
    .field { margin-bottom: 1.6rem; }

    .field label {
      display: block;
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.22em;
      color: var(--muted-2); text-transform: uppercase;
      margin-bottom: 0.55rem;
    }

    .field input {
      width: 100%;
      background: transparent;
      border: none; border-bottom: 1px solid var(--border);
      color: var(--text);
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.45rem; font-weight: 300;
      padding: 0.4rem 0 0.6rem;
      outline: none;
      transition: border-color 0.25s, color 0.25s;
      -moz-appearance: textfield;
    }
    .field input::-webkit-inner-spin-button,
    .field input::-webkit-outer-spin-button { -webkit-appearance: none; }
    .field input::placeholder {
      color: var(--muted); font-style: italic;
    }
    .panel.fetch  .field input:focus { border-bottom-color: var(--accent); color: var(--accent); }
    .panel.update .field input:focus { border-bottom-color: var(--danger); color: var(--danger); }

    /* ─── Buttons ─── */
    .btn {
      width: 100%;
      border: none; cursor: pointer;
      font-family: 'Bebas Neue', sans-serif;
      font-size: 1.15rem; letter-spacing: 0.2em;
      padding: 1rem 1.5rem;
      transition: transform 0.15s, box-shadow 0.2s, opacity 0.2s;
      position: relative; overflow: hidden;
    }
    .btn::after {
      content: ''; position: absolute; inset: 0;
      background: white; opacity: 0; transition: opacity 0.2s;
    }
    .btn:hover { transform: translateY(-2px); }
    .btn:hover::after { opacity: 0.07; }
    .btn:active { transform: translateY(0); box-shadow: none; }

    .btn-fetch {
      background: var(--accent-dim);
      color: var(--accent);
      border: 1px solid var(--accent);
    }
    .btn-fetch:hover { box-shadow: 0 6px 28px var(--accent-glow); }

    .btn-update {
      background: rgba(224, 112, 96, 0.10);
      color: var(--danger);
      border: 1px solid var(--danger);
    }
    .btn-update:hover { box-shadow: 0 6px 28px rgba(224,112,96,0.2); }

    /* Method badge */
    .method-badge {
      display: inline-block;
      font-family: 'DM Mono', monospace;
      font-size: 0.52rem; letter-spacing: 0.2em;
      padding: 0.2rem 0.55rem;
      border: 1px solid; margin-bottom: 2rem;
      text-transform: uppercase;
    }
    .panel.fetch  .method-badge { color: var(--muted-2); border-color: var(--border); }
    .panel.update .method-badge { color: var(--muted-2); border-color: var(--border); }

    /* ─── Footer strip ─── */
    .footer-strip {
      width: 100%; max-width: 900px;
      margin-top: 1.5px;
      background: var(--surface);
      border: 1px solid var(--border);
      border-top: none;
      display: flex; align-items: center; justify-content: space-between;
      padding: 1rem 2rem;
      opacity: 0; animation: fadeUp 0.5s ease 1.1s forwards;
    }
    .footer-strip .fs-left {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.2em;
      color: var(--muted); text-transform: uppercase;
    }
    .footer-strip .fs-right {
      display: flex; align-items: center; gap: 0.5rem;
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.15em;
      color: var(--muted); text-transform: uppercase;
    }
    .dot-live {
      width: 6px; height: 6px; border-radius: 50%;
      background: #4caf82; box-shadow: 0 0 8px #4caf82;
      animation: blink 2s ease-in-out infinite;
    }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:.3} }

    /* ─── Ticker ─── */
    .ticker {
      position: fixed; bottom: 0; left: 0; right: 0;
      border-top: 1px solid var(--border);
      background: rgba(10,10,10,0.9);
      backdrop-filter: blur(8px);
      padding: 9px 0; overflow: hidden; z-index: 100;
    }
    .ticker-inner {
      display: flex; gap: 72px;
      width: max-content;
      animation: scroll 22s linear infinite;
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.24em;
      color: var(--muted); text-transform: uppercase;
    }
    .ticker-inner span { white-space: nowrap; }
    .ticker-inner .hi { color: var(--accent); }
    @keyframes scroll { from{transform:translateX(0)} to{transform:translateX(-50%)} }

    /* ─── Animations ─── */
    @keyframes slideDown { from{transform:translateY(-100%);opacity:0} to{transform:translateY(0);opacity:1} }
    @keyframes riseIn    { from{opacity:0;transform:translateY(24px)} to{opacity:1;transform:translateY(0)} }
    @keyframes fadeUp    { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }

    /* ─── Responsive ─── */
    @media (max-width: 640px) {
      .top-bar { padding: 1.1rem 1.4rem; }
      .nav-links { display: none; }
      .grid { grid-template-columns: 1fr; gap: 1.5px; }
      .panel { padding: 2.2rem 1.8rem; }
      .hero-title { font-size: 2.6rem; }
    }
  </style>
</head>
<body>

<div class="bg-glow"></div>

<!-- Top bar -->
<nav class="top-bar">
  <span class="logo">Artistica</span>
  <ul class="nav-links">
    <li><a href="#">Registry</a></li>
    <li><a href="getArtists">Artist</a></li>
  </ul>
  <span class="nav-badge">Artist Registry v1.0</span>
</nav>

<main class="page">

  <!-- Hero -->
  <div class="hero">
    <p class="hero-eyebrow">// artist_registry.exe</p>
    <h1 class="hero-title"><em>Manage</em> the<br>Artist Registry</h1>
    <p class="hero-sub">Fetch · Update · Persist</p>
  </div>

  <!-- Section label -->
  <div class="section-divider">
    <span>Select Operation</span>
  </div>

  <!-- Dual form grid -->
  <div class="grid">

    <!-- PANEL 1 — Fetch Artist -->
    <div class="panel fetch">
      <div class="corner-mark tl"></div>
      <div class="corner-mark br"></div>

      <p class="panel-tag">Operation 01</p>
      <h2 class="panel-title"><em>Fetch</em> Artist</h2>
      <p class="panel-desc">Retrieve by ID</p>
      <span class="method-badge">GET · /getArtist</span>

      <form action="getArtist" method="get">
        <div class="field">
          <label for="fetchId">Artist ID</label>
          <input type="number" id="fetchId" name="id" placeholder="e.g. 2" required />
        </div>
        <button type="submit" class="btn btn-fetch">Fetch Artist →</button>
      </form>
      <br>
      <form action="getId" method="get">
        <div class="field">
          <label for="fetchId">Artist Name</label>
          <input type="text" id="fetchId" name="name" placeholder="e.g. J. Cole" required />
        </div>
        <button type="submit" class="btn btn-fetch">Fetch ID →</button>
      </form>
    </div>

    <!-- PANEL 2 — Add Artist -->
    <div class="panel update">
      <div class="corner-mark tl"></div>
      <div class="corner-mark br"></div>

      <p class="panel-tag">Operation 02</p>
      <h2 class="panel-title"><em>Add</em> Artist</h2>
      <p class="panel-desc">Insert into registry</p>
      <span class="method-badge">POST · /addArtist</span>

      <form action="addArtist" method="post">
        <div class="field">
          <label for="addId">Artist ID</label>
          <input type="number" id="addId" name="id" placeholder="e.g. 3" required />
        </div>
        <div class="field">
          <label for="addName">Artist Name</label>
          <input type="text" id="addName" name="name" placeholder="e.g. Daft Punk" required />
        </div>
        <button type="submit" class="btn btn-update">Add to Registry →</button>
      </form>
    </div>

  </div>

  <!-- Footer strip -->
  <div class="footer-strip">
    <span class="fs-left">Artistica Registry · Two operations available</span>
    <span class="fs-right"><span class="dot-live"></span>System Online</span>
  </div>

</main>

<!-- Ticker -->
<div class="ticker">
  <div class="ticker-inner">
    <span>ARTISTICA <span class="hi">✦</span></span>
    <span>FETCH BY ID</span>
    <span>ADD TO REGISTRY <span class="hi">✦</span></span>
    <span>ARTIST MANAGEMENT</span>
    <span>GET · POST <span class="hi">✦</span></span>
    <span>REGISTRY PROTOCOL ACTIVE</span>
    <span>ARTISTICA <span class="hi">✦</span></span>
    <span>FETCH BY ID</span>
    <span>ADD TO REGISTRY <span class="hi">✦</span></span>
    <span>ARTIST MANAGEMENT</span>
    <span>GET · POST <span class="hi">✦</span></span>
    <span>REGISTRY PROTOCOL ACTIVE</span>
  </div>
</div>

</body>
</html>
