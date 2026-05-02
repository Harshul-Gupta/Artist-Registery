<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Artistica — Library</title>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Bebas+Neue&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:          #0a0a0a;
      --surface:     #111111;
      --surface-2:   #141414;
      --border:      #1e1e1e;
      --border-h:    #2e2e2e;
      --text:        #e8e2d9;
      --muted:       #4a4540;
      --muted-2:     #6a6560;
      --accent:      #c9a96e;
      --accent-dim:  rgba(201,169,110,0.10);
      --accent-glow: rgba(201,169,110,0.20);
    }

    html, body { height: 100%; background: var(--bg); color: var(--text); }

    /* Grain */
    body::before {
      content: ''; position: fixed; inset: 0; pointer-events: none; z-index: 9999;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
      opacity: 0.45;
    }

    /* Ambient glow */
    .bg-glow {
      position: fixed; top: -10%; left: 50%; transform: translateX(-50%);
      width: 80vw; height: 50vh;
      background: radial-gradient(ellipse at center, rgba(201,169,110,0.05) 0%, transparent 70%);
      pointer-events: none; z-index: 0;
    }

    /* ─── Top bar ─── */
    .top-bar {
      position: fixed; top: 0; left: 0; right: 0; z-index: 200;
      display: flex; align-items: center; justify-content: space-between;
      padding: 1.3rem 3rem;
      border-bottom: 1px solid var(--border);
      background: rgba(10,10,10,0.88); backdrop-filter: blur(16px);
      animation: slideDown 0.6s ease forwards;
    }
    .logo {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 1.15rem; letter-spacing: 0.38em; color: var(--accent);
    }
    .nav-links { display: flex; gap: 2.4rem; list-style: none; }
    .nav-links a {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.22em;
      color: var(--muted-2); text-decoration: none; text-transform: uppercase;
      transition: color 0.2s;
    }
    .nav-links a:hover, .nav-links a.active { color: var(--accent); }
    .nav-badge {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.2em;
      color: var(--muted); text-transform: uppercase;
    }

    /* ─── Page ─── */
    .page {
      position: relative; z-index: 1;
      min-height: 100vh;
      padding: 7.5rem 2rem 6rem;
      display: flex; flex-direction: column; align-items: center;
    }

    /* ─── Hero ─── */
    .hero {
      width: 100%; max-width: 960px;
      display: flex; align-items: flex-end; justify-content: space-between;
      margin-bottom: 2.8rem;
      opacity: 0; animation: fadeUp 0.8s ease 0.2s forwards;
    }
    .hero-left {}
    .hero-eyebrow {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.32em;
      color: var(--accent); text-transform: uppercase; margin-bottom: 0.6rem;
    }
    .hero-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: clamp(2.4rem, 5vw, 4rem);
      font-weight: 300; line-height: 0.95; letter-spacing: -0.01em;
    }
    .hero-title em { font-style: italic; color: var(--accent); }
    .hero-count {
      font-family: 'Bebas Neue', sans-serif;
      font-size: clamp(3rem, 6vw, 5rem);
      color: var(--accent); line-height: 1; letter-spacing: 0.04em;
      opacity: 0.18;
    }

    /* ─── Section divider ─── */
    .section-divider {
      width: 100%; max-width: 960px;
      display: flex; align-items: center; gap: 1.5rem;
      margin-bottom: 1px;
      opacity: 0; animation: fadeUp 0.6s ease 0.4s forwards;
    }
    .section-divider::before, .section-divider::after {
      content: ''; flex: 1; height: 1px; background: var(--border);
    }
    .section-divider span {
      font-family: 'DM Mono', monospace;
      font-size: 0.56rem; letter-spacing: 0.3em;
      color: var(--muted); text-transform: uppercase; white-space: nowrap;
    }

    /* ─── Table wrapper ─── */
    .table-wrap {
      width: 100%; max-width: 960px;
      border: 1px solid var(--border);
      background: var(--surface);
      position: relative; overflow: hidden;
      opacity: 0; animation: riseIn 0.9s cubic-bezier(0.22,1,0.36,1) 0.5s forwards;
    }

    /* Top accent */
    .table-wrap::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(90deg, transparent, var(--accent), transparent);
    }

    /* Corner marks */
    .table-wrap .c { position: absolute; width: 12px; height: 12px; border-style: solid; border-color: var(--accent); opacity: 0.4; }
    .table-wrap .c.tl { top: 8px; left: 8px; border-width: 1px 0 0 1px; }
    .table-wrap .c.tr { top: 8px; right: 8px; border-width: 1px 1px 0 0; }
    .table-wrap .c.bl { bottom: 8px; left: 8px; border-width: 0 0 1px 1px; }
    .table-wrap .c.br { bottom: 8px; right: 8px; border-width: 0 1px 1px 0; }

    /* ─── Table header ─── */
    .tbl-head {
      display: grid; grid-template-columns: 80px 1fr 120px;
      padding: 1.1rem 2.5rem;
      border-bottom: 1px solid var(--border);
      background: rgba(201,169,110,0.04);
    }
    .tbl-head span {
      font-family: 'DM Mono', monospace;
      font-size: 0.56rem; letter-spacing: 0.26em;
      color: var(--muted); text-transform: uppercase;
    }
    .tbl-head span:last-child { text-align: right; }

    /* ─── Table rows ─── */
    .tbl-body { position: relative; }

    .tbl-row {
      display: grid; grid-template-columns: 80px 1fr 120px;
      align-items: center;
      padding: 1.25rem 2.5rem;
      border-bottom: 1px solid var(--border);
      transition: background 0.2s;
      position: relative; overflow: hidden;
    }
    .tbl-row:last-child { border-bottom: none; }
    .tbl-row::before {
      content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 2px;
      background: var(--accent); transform: scaleY(0);
      transition: transform 0.2s cubic-bezier(0.22,1,0.36,1);
      transform-origin: bottom;
    }
    .tbl-row:hover { background: var(--surface-2); }
    .tbl-row:hover::before { transform: scaleY(1); }

    /* Row number */
    .row-index {
      font-family: 'DM Mono', monospace;
      font-size: 0.6rem; letter-spacing: 0.15em;
      color: var(--muted); padding-top: 2px;
    }

    /* Artist ID */
    .row-id {
      font-family: 'DM Mono', monospace;
      font-size: 0.68rem; letter-spacing: 0.15em;
      color: var(--accent);
    }

    /* Artist Name */
    .row-name {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.3rem; font-weight: 300;
      color: var(--text); letter-spacing: 0.01em;
    }

    /* Action cell */
    .row-action { text-align: right; }
    .row-action a {
      font-family: 'DM Mono', monospace;
      font-size: 0.56rem; letter-spacing: 0.2em; text-transform: uppercase;
      color: var(--muted-2); text-decoration: none;
      padding: 0.35rem 0.75rem; border: 1px solid var(--border);
      transition: color 0.2s, border-color 0.2s, background 0.2s;
      display: inline-block;
    }
    .row-action a:hover {
      color: var(--accent); border-color: var(--accent);
      background: var(--accent-dim);
    }

    /* Empty state */
    .empty-state {
      padding: 5rem 2rem; text-align: center;
    }
    .empty-state p {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.6rem; font-weight: 300; font-style: italic;
      color: var(--muted); margin-bottom: 0.5rem;
    }
    .empty-state small {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.2em;
      color: var(--muted); text-transform: uppercase;
    }

    /* ─── Pagination ─── */
    .pagination-bar {
      width: 100%; max-width: 960px;
      display: flex; align-items: center; justify-content: space-between;
      padding: 1.1rem 2.5rem;
      border: 1px solid var(--border); border-top: none;
      background: rgba(201,169,110,0.03);
      opacity: 0; animation: fadeUp 0.6s ease 1s forwards;
    }

    .page-info {
      font-family: 'DM Mono', monospace;
      font-size: 0.58rem; letter-spacing: 0.18em;
      color: var(--muted-2); text-transform: uppercase;
    }
    .page-info strong { color: var(--accent); font-weight: 400; }

    .page-controls { display: flex; align-items: center; gap: 0.6rem; }

    .page-btn {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 0.85rem; letter-spacing: 0.15em;
      color: var(--muted-2);
      background: transparent; border: 1px solid var(--border);
      padding: 0.45rem 1rem; cursor: pointer;
      transition: color 0.2s, border-color 0.2s, background 0.2s, transform 0.15s;
      text-decoration: none; display: inline-block;
    }
    .page-btn:hover:not(.disabled) {
      color: var(--accent); border-color: var(--accent);
      background: var(--accent-dim); transform: translateY(-1px);
    }
    .page-btn.active {
      color: var(--bg); background: var(--accent);
      border-color: var(--accent);
    }
    .page-btn.disabled {
      opacity: 0.25; cursor: not-allowed; pointer-events: none;
    }

    .page-dots {
      font-family: 'DM Mono', monospace;
      font-size: 0.7rem; color: var(--muted);
      padding: 0 0.2rem;
    }

    /* ─── Footer strip ─── */
    .footer-strip {
      width: 100%; max-width: 960px;
      margin-top: 1.5rem;
      display: flex; align-items: center; justify-content: space-between;
      opacity: 0; animation: fadeUp 0.5s ease 1.2s forwards;
    }
    .footer-strip span {
      font-family: 'DM Mono', monospace;
      font-size: 0.56rem; letter-spacing: 0.2em;
      color: var(--muted); text-transform: uppercase;
    }
    .dot-live {
      display: inline-block; width: 6px; height: 6px; border-radius: 50%;
      background: #4caf82; box-shadow: 0 0 8px #4caf82;
      margin-right: 0.5rem; vertical-align: middle;
      animation: blink 2s ease-in-out infinite;
    }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:.3} }

    /* ─── Ticker ─── */
    .ticker {
      position: fixed; bottom: 0; left: 0; right: 0;
      border-top: 1px solid var(--border);
      background: rgba(10,10,10,0.9); backdrop-filter: blur(8px);
      padding: 9px 0; overflow: hidden; z-index: 100;
    }
    .ticker-inner {
      display: flex; gap: 72px; width: max-content;
      animation: scroll 22s linear infinite;
      font-family: 'DM Mono', monospace;
      font-size: 0.56rem; letter-spacing: 0.24em;
      color: var(--muted); text-transform: uppercase;
    }
    .ticker-inner span { white-space: nowrap; }
    .ticker-inner .hi { color: var(--accent); }
    @keyframes scroll { from{transform:translateX(0)} to{transform:translateX(-50%)} }

    /* ─── Animations ─── */
    @keyframes slideDown { from{transform:translateY(-100%);opacity:0} to{transform:translateY(0);opacity:1} }
    @keyframes riseIn    { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
    @keyframes fadeUp    { from{opacity:0;transform:translateY(10px)} to{opacity:1;transform:translateY(0)} }

    /* Stagger rows */
    .tbl-row { opacity: 0; animation: fadeUp 0.4s ease forwards; }
    .tbl-row:nth-child(1)  { animation-delay: 0.55s; }
    .tbl-row:nth-child(2)  { animation-delay: 0.60s; }
    .tbl-row:nth-child(3)  { animation-delay: 0.65s; }
    .tbl-row:nth-child(4)  { animation-delay: 0.70s; }
    .tbl-row:nth-child(5)  { animation-delay: 0.75s; }
    .tbl-row:nth-child(6)  { animation-delay: 0.80s; }
    .tbl-row:nth-child(7)  { animation-delay: 0.85s; }
    .tbl-row:nth-child(8)  { animation-delay: 0.90s; }
    .tbl-row:nth-child(9)  { animation-delay: 0.95s; }
    .tbl-row:nth-child(10) { animation-delay: 1.00s; }

    @media (max-width: 640px) {
      .top-bar { padding: 1.1rem 1.4rem; }
      .nav-links { display: none; }
      .tbl-head, .tbl-row { grid-template-columns: 60px 1fr; padding: 1rem 1.4rem; }
      .tbl-head span:last-child, .row-action { display: none; }
      .pagination-bar { padding: 1rem 1.4rem; }
      .hero { flex-direction: column; align-items: flex-start; gap: 0.5rem; }
    }
  </style>
</head>
<body>

<div class="bg-glow"></div>

<%
    List<Object> artists = (List<Object>) request.getAttribute("artists");
    if (artists == null) artists = new java.util.ArrayList<>();

    int pageSize    = 10;
    int totalItems  = artists.size();
    int currentPage = 1;
    try { currentPage = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
    if (currentPage < 1) currentPage = 1;
    int totalPages  = (int) Math.ceil((double) totalItems / pageSize);
    if (totalPages < 1) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;
    int startIndex  = (currentPage - 1) * pageSize;
    int endIndex    = Math.min(startIndex + pageSize, totalItems);

    pageContext.setAttribute("artists",     artists);
    pageContext.setAttribute("totalItems",  totalItems);
    pageContext.setAttribute("currentPage", currentPage);
    pageContext.setAttribute("totalPages",  totalPages);
    pageContext.setAttribute("startIndex",  startIndex);
    pageContext.setAttribute("endIndex",    endIndex);
%>

<!-- Top bar -->
<nav class="top-bar">
  <span class="logo">Artistica</span>
  <ul class="nav-links">
    <li><a href="index">Registry</a></li>
    <li><a href="artists" class="active">Library</a></li>
  </ul>
  <span class="nav-badge">Artist Library</span>
</nav>

<main class="page">

  <!-- Hero -->
  <div class="hero">
    <div class="hero-left">
      <p class="hero-eyebrow">// artist_library.db</p>
      <h1 class="hero-title"><em>Artist</em><br>Library</h1>
    </div>
    <div class="hero-count">${totalItems}</div>
  </div>

  <!-- Divider -->
  <div class="section-divider">
    <span>Page ${currentPage} of ${totalPages} &nbsp;·&nbsp; Showing ${startIndex + 1}–${endIndex} of ${totalItems} artists</span>
  </div>

  <!-- Table -->
  <div class="table-wrap">
    <div class="c tl"></div><div class="c tr"></div>
    <div class="c bl"></div><div class="c br"></div>

    <!-- Header -->
    <div class="tbl-head">
      <span>#</span>
      <span>Artist Name</span>
      <span style="text-align:right">View</span>
    </div>

    <!-- Rows -->
    <div class="tbl-body">
      <% if (totalItems == 0) { %>
        <div class="empty-state">
          <p>No artists found.</p>
          <small>The registry is empty</small>
        </div>
      <% } else {
           for (int i = startIndex; i < endIndex; i++) {
             Object artistObj = artists.get(i);
             // Works with any Artist bean that has getId() and getName()
             int    artId   = (int) artistObj.getClass().getMethod("getId").invoke(artistObj);
             String artName = (String) artistObj.getClass().getMethod("getName").invoke(artistObj);
             int    rowNum  = i + 1;
             String rowNumStr  = (rowNum < 10 ? "0" : "") + rowNum;
             String artIdStr   = (artId  < 10 ? "ART-00" : artId < 100 ? "ART-0" : "ART-") + artId;
      %>
        <div class="tbl-row">
          <span class="row-index"><%= rowNumStr %></span>
          <div>
            <div class="row-id"><%= artIdStr %></div>
            <div class="row-name"><%= artName %></div>
          </div>
          <div class="row-action">
            <a href="getArtist?id=<%= artId %>">View &rarr;</a>
          </div>
        </div>
      <% } } %>
    </div>
  </div>

  <!-- Pagination bar -->
  <div class="pagination-bar">
    <span class="page-info">
      Page <strong>${currentPage}</strong> of <strong>${totalPages}</strong>
    </span>

    <div class="page-controls">
      <%-- Prev --%>
      <% if (currentPage <= 1) { %>
        <span class="page-btn disabled">&larr; Prev</span>
      <% } else { %>
        <a href="?page=<%= currentPage - 1 %>" class="page-btn">&larr; Prev</a>
      <% } %>

      <%-- Page number buttons with ellipsis --%>
      <% boolean leftDot = false, rightDot = false;
         for (int p = 1; p <= totalPages; p++) {
           boolean near = (p >= currentPage - 1 && p <= currentPage + 1);
           if (p == 1 || p == totalPages || near) { %>
             <% if (p == currentPage) { %>
               <span class="page-btn active"><%= p %></span>
             <% } else { %>
               <a href="?page=<%= p %>" class="page-btn"><%= p %></a>
             <% } %>
           <% } else if (p < currentPage - 1 && !leftDot)  { leftDot  = true; %><span class="page-dots">&middot;&middot;&middot;</span>
           <% } else if (p > currentPage + 1 && !rightDot) { rightDot = true; %><span class="page-dots">&middot;&middot;&middot;</span>
           <% } %>
      <% } %>

      <%-- Next --%>
      <% if (currentPage >= totalPages) { %>
        <span class="page-btn disabled">Next &rarr;</span>
      <% } else { %>
        <a href="?page=<%= currentPage + 1 %>" class="page-btn">Next &rarr;</a>
      <% } %>
    </div>
  </div>

  <!-- Footer -->
  <div class="footer-strip">
    <span><span class="dot-live"></span>Registry Online</span>
    <span>Artistica · Artist Library</span>
  </div>

</main>

<!-- Ticker -->
<div class="ticker">
  <div class="ticker-inner">
    <span>ARTISTICA <span class="hi">✦</span></span>
    <span>ARTIST LIBRARY</span>
    <span>BROWSE THE REGISTRY <span class="hi">✦</span></span>
    <span>${totalItems} ARTISTS INDEXED</span>
    <span>PAGE ${currentPage} OF ${totalPages} <span class="hi">✦</span></span>
    <span>FETCH · EXPLORE · DISCOVER</span>
    <span>ARTISTICA <span class="hi">✦</span></span>
    <span>ARTIST LIBRARY</span>
    <span>BROWSE THE REGISTRY <span class="hi">✦</span></span>
    <span>${totalItems} ARTISTS INDEXED</span>
    <span>PAGE ${currentPage} OF ${totalPages} <span class="hi">✦</span></span>
    <span>FETCH · EXPLORE · DISCOVER</span>
  </div>
</div>

</body>
</html>
