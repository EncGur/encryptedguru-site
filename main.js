// Progressive enhancement only. Every page works without this script:
// the More menu is a native <details>, and referral codes remain selectable text.

// More menu: add outside-click, Escape, and focus-departure dismissal.
const menus = document.querySelectorAll(".nav-more");
if (menus.length) {
  document.addEventListener("click", (event) => {
    menus.forEach((menu) => {
      if (menu.open && !menu.contains(event.target)) menu.open = false;
    });
  });
  menus.forEach((menu) => {
    menu.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && menu.open) {
        menu.open = false;
        menu.querySelector("summary").focus();
      }
    });
    menu.addEventListener("focusout", (event) => {
      if (event.relatedTarget && !menu.contains(event.relatedTarget)) menu.open = false;
    });
  });
}

// Copy controls: revealed only when the Clipboard API exists. Focus stays on
// the button (no disabled toggling), and the status text is cleared before it
// is set again so assistive technology re-announces repeated copies.
if (navigator.clipboard && navigator.clipboard.writeText) {
  document.querySelectorAll("[data-copy]").forEach((button) => {
    const holder = button.closest(".referral-value");
    const status = holder ? holder.querySelector(".copy-status") : null;
    button.hidden = false;
    button.addEventListener("click", async () => {
      if (button.dataset.busy) return;
      button.dataset.busy = "1";
      if (status) status.textContent = "";
      let message = "Copied to clipboard.";
      try {
        await navigator.clipboard.writeText(button.dataset.copy);
      } catch (error) {
        message = "Copy unavailable. Select the code or use the link below.";
      }
      if (status) status.textContent = message;
      delete button.dataset.busy;
    });
  });
}
