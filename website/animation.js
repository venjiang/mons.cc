const terminal = document.querySelector(".terminal-body");
const finalLine = terminal?.querySelector(".line-fifteen");
const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

if (terminal && finalLine && !reducedMotion.matches) {
  const replay = () => {
    terminal.classList.remove("is-playing");
    requestAnimationFrame(() => {
      requestAnimationFrame(() => terminal.classList.add("is-playing"));
    });
  };

  finalLine.addEventListener("animationend", () => {
    window.setTimeout(replay, 5800);
  });

  terminal.classList.add("is-playing");
}
