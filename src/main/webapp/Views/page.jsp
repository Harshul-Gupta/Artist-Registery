<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored= "false"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>NUM + NUM</title>
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --bg: #0a0a0a;
      --surface: #111111;
      --border: #2a2a2a;
      --accent: #e8ff47;
      --accent2: #ff6b35;
      --text: #f0ede6;
      --muted: #555;
      --glow: rgba(232, 255, 71, 0.15);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'DM Mono', monospace;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      position: relative;
    }

    /* Grid background */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background-image:
        linear-gradient(var(--border) 1px, transparent 1px),
        linear-gradient(90deg, var(--border) 1px, transparent 1px);
      background-size: 60px 60px;
      opacity: 0.35;
      pointer-events: none;
    }

    /* Glowing orb */
    body::after {
      content: '';
      position: fixed;
      width: 600px;
      height: 600px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(232,255,71,0.07) 0%, transparent 70%);
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      pointer-events: none;
      animation: pulse 4s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 0.6; transform: translate(-50%, -50%) scale(1); }
      50% { opacity: 1; transform: translate(-50%, -50%) scale(1.08); }
    }

    .card {
      position: relative;
      z-index: 10;
      background: var(--surface);
      border: 1px solid var(--border);
      padding: 56px 52px 48px;
      width: 480px;
      max-width: 95vw;
      animation: slideUp 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(40px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* Corner accents */
    .card::before, .card::after {
      content: '';
      position: absolute;
      width: 20px;
      height: 20px;
      border-color: var(--accent);
      border-style: solid;
    }
    .card::before { top: -1px; left: -1px; border-width: 2px 0 0 2px; }
    .card::after  { bottom: -1px; right: -1px; border-width: 0 2px 2px 0; }

    .label-top {
      font-family: 'DM Mono', monospace;
      font-size: 10px;
      letter-spacing: 0.25em;
      color: var(--accent);
      text-transform: uppercase;
      margin-bottom: 12px;
    }

    h1 {
      font-family: 'Bebas Neue', sans-serif;
      font-size: clamp(52px, 10vw, 80px);
      line-height: 0.9;
      letter-spacing: 0.02em;
      color: var(--text);
      margin-bottom: 8px;
    }

    h1 span {
      color: var(--accent);
    }

    .subtitle {
      font-size: 11px;
      color: var(--muted);
      letter-spacing: 0.12em;
      margin-bottom: 44px;
    }

    .fields {
      display: grid;
      grid-template-columns: 1fr auto 1fr;
      gap: 0;
      align-items: end;
      margin-bottom: 32px;
    }

    .field-group {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    label {
      font-size: 10px;
      letter-spacing: 0.2em;
      color: var(--muted);
      text-transform: uppercase;
    }

    input[type="number"] {
      background: transparent;
      border: none;
      border-bottom: 1px solid var(--border);
      color: var(--text);
      font-family: 'Bebas Neue', sans-serif;
      font-size: 42px;
      letter-spacing: 0.04em;
      width: 100%;
      padding: 6px 0 8px;
      outline: none;
      transition: border-color 0.2s, color 0.2s;
      -moz-appearance: textfield;
    }
    input[type="number"]::-webkit-inner-spin-button,
    input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; }
    input[type="number"]:focus {
      border-bottom-color: var(--accent);
      color: var(--accent);
    }
    input[type="number"]::placeholder {
      color: #2e2e2e;
    }

    .operator {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 36px;
      color: var(--accent2);
      padding: 0 16px 14px;
      line-height: 1;
      user-select: none;
    }

    .divider {
      height: 1px;
      background: linear-gradient(to right, transparent, var(--border), transparent);
      margin-bottom: 28px;
    }

    button {
      width: 100%;
      background: var(--accent);
      color: #000;
      border: none;
      padding: 16px 24px;
      font-family: 'Bebas Neue', sans-serif;
      font-size: 22px;
      letter-spacing: 0.15em;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: transform 0.15s, box-shadow 0.15s;
      margin-bottom: 28px;
    }

    button::after {
      content: '';
      position: absolute;
      inset: 0;
      background: white;
      opacity: 0;
      transition: opacity 0.2s;
    }

    button:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 32px rgba(232,255,71,0.25);
    }
    button:hover::after { opacity: 0.08; }
    button:active { transform: translateY(0); box-shadow: none; }

    .result-area {
      min-height: 64px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      opacity: 0;
      transform: translateY(10px);
      transition: opacity 0.4s ease, transform 0.4s ease;
    }

    .result-area.visible {
      opacity: 1;
      transform: translateY(0);
    }

    .result-label {
      font-size: 10px;
      letter-spacing: 0.2em;
      color: var(--muted);
      text-transform: uppercase;
    }

    .result-value {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 56px;
      color: var(--accent);
      letter-spacing: 0.02em;
      line-height: 1;
      text-shadow: 0 0 40px rgba(232,255,71,0.4);
      animation: popIn 0.35s cubic-bezier(0.34, 1.56, 0.64, 1) both;
    }

    @keyframes popIn {
      from { transform: scale(0.6); opacity: 0; }
      to   { transform: scale(1);   opacity: 1; }
    }

    .error-msg {
      font-size: 11px;
      color: var(--accent2);
      letter-spacing: 0.1em;
    }

    .ticker {
      position: fixed;
      bottom: 0; left: 0; right: 0;
      border-top: 1px solid var(--border);
      padding: 10px 0;
      overflow: hidden;
      z-index: 20;
    }
    .ticker-inner {
      display: flex;
      gap: 80px;
      width: max-content;
      animation: ticker 18s linear infinite;
      font-size: 10px;
      letter-spacing: 0.25em;
      color: var(--muted);
      text-transform: uppercase;
    }
    @keyframes ticker {
      from { transform: translateX(0); }
      to   { transform: translateX(-50%); }
    }
    .ticker-inner span { white-space: nowrap; }
    .ticker-inner .hi { color: var(--accent); }
  </style>
</head>
<body>

  <div class="card">
    <div class="label-top">// arithmetic_unit.exe</div>
    <h1>ADD <span>IT</span><br>UP.</h1>

    <div class="divider"></div>

      <div class="result-value">ARTIST: ${a1}</div>
      <div class="error-msg" id="errorMsg"></div>
    </div>

  <div class="ticker">
    <div class="ticker-inner">
      <span>ADDITION <span class="hi">✦</span></span>
      <span>ARITHMETIC ENGINE</span>
      <span>TWO INPUTS <span class="hi">✦</span></span>
      <span>ONE TRUTH</span>
      <span>SUM PROTOCOL ACTIVE <span class="hi">✦</span></span>
      <span>INPUT → PROCESS → OUTPUT</span>
      <span>ADDITION <span class="hi">✦</span></span>
      <span>ARITHMETIC ENGINE</span>
      <span>TWO INPUTS <span class="hi">✦</span></span>
      <span>ONE TRUTH</span>
      <span>SUM PROTOCOL ACTIVE <span class="hi">✦</span></span>
      <span>INPUT → PROCESS → OUTPUT</span>
    </div>
  </div>

  
</body>
</html>