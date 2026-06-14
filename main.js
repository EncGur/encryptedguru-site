const canvas = document.getElementById("ambient");
const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

if (canvas && !reduceMotion.matches) {
  const ctx = canvas.getContext("2d");

  let width = 0;
  let height = 0;
  let points = [];

  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

    const count = Math.max(42, Math.floor((width * height) / 23000));
    points = Array.from({ length: count }, () => ({
      x: Math.random() * width,
      y: Math.random() * height,
      vx: (Math.random() - 0.5) * 0.18,
      vy: (Math.random() - 0.5) * 0.18,
      r: Math.random() * 1.8 + 0.7,
    }));
  }

  function draw() {
    ctx.clearRect(0, 0, width, height);

    for (const point of points) {
      point.x += point.vx;
      point.y += point.vy;

      if (point.x < -20) point.x = width + 20;
      if (point.x > width + 20) point.x = -20;
      if (point.y < -20) point.y = height + 20;
      if (point.y > height + 20) point.y = -20;
    }

    for (let i = 0; i < points.length; i += 1) {
      for (let j = i + 1; j < points.length; j += 1) {
        const a = points[i];
        const b = points[j];
        const dx = a.x - b.x;
        const dy = a.y - b.y;
        const dist = Math.hypot(dx, dy);
        if (dist < 145) {
          const alpha = (1 - dist / 145) * 0.2;
          ctx.strokeStyle = `rgba(113, 212, 64, ${alpha})`;
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(a.x, a.y);
          ctx.lineTo(b.x, b.y);
          ctx.stroke();
        }
      }
    }

    for (const point of points) {
      ctx.fillStyle = "rgba(162, 255, 104, 0.48)";
      ctx.beginPath();
      ctx.arc(point.x, point.y, point.r, 0, Math.PI * 2);
      ctx.fill();
    }

    requestAnimationFrame(draw);
  }

  resize();
  draw();
  window.addEventListener("resize", resize);
}
