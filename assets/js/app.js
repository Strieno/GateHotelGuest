/* ============================================================
   The Gate Hotel & Apartments — Guest Portal
   app.js — i18n, Dammam clock, weather, copy actions,
   facility status, scrollspy, toasts and progressive polish.
   ============================================================ */

(function () {
  "use strict";

  var STORAGE_KEY = "gate-hotel-lang";
  var TIME_ZONE = "Asia/Riyadh";

  var currentLang = "en";
  var toastTimer = null;
  var weatherData = null;

  /* ---------- helpers ---------- */

  function getEl(id) {
    return document.getElementById(id);
  }

  function getStore() {
    try {
      return window.localStorage;
    } catch (e) {
      return null;
    }
  }

  /* ---------- language ---------- */

  function detectInitialLang() {
    var store = getStore();
    if (store) {
      var saved = store.getItem(STORAGE_KEY);
      if (saved === "en" || saved === "ar") {
        return saved;
      }
    }
    var navLang = ((navigator.language || (navigator.languages && navigator.languages[0]) || "en") + "").toLowerCase();
    return navLang.indexOf("ar") === 0 ? "ar" : "en";
  }

  function applyLang(lang) {
    var t = window.TRANSLATIONS[lang];
    if (!t) {
      return;
    }
    currentLang = lang;

    var html = document.documentElement;
    html.setAttribute("lang", lang);
    html.setAttribute("dir", lang === "ar" ? "rtl" : "ltr");

    document.title = t.title;

    var metaDesc = document.querySelector('meta[name="description"]');
    if (metaDesc) {
      metaDesc.setAttribute("content", t.metaDescription);
    }

    document.querySelectorAll("[data-i18n]").forEach(function (el) {
      var value = t[el.getAttribute("data-i18n")];
      if (value != null) {
        el.textContent = value;
      }
    });

    document.querySelectorAll("[data-i18n-html]").forEach(function (el) {
      var value = t[el.getAttribute("data-i18n-html")];
      if (value != null) {
        el.innerHTML = value;
      }
    });

    document.querySelectorAll("[data-i18n-aria]").forEach(function (el) {
      var value = t[el.getAttribute("data-i18n-aria")];
      if (value != null) {
        el.setAttribute("aria-label", value);
      }
    });

    /* The bilingual name line always carries the *other* language. */
    var altName = document.querySelector(".hero-arabic-name");
    if (altName) {
      altName.setAttribute("lang", lang === "ar" ? "en" : "ar");
      altName.setAttribute("dir", lang === "ar" ? "ltr" : "rtl");
    }

    var store = getStore();
    if (store) {
      try {
        store.setItem(STORAGE_KEY, lang);
      } catch (e) { /* storage unavailable */ }
    }

    renderClock();
    renderStatuses();
    renderWeather();
  }

  function toggleLang() {
    applyLang(currentLang === "en" ? "ar" : "en");
  }

  /* ---------- Dammam clock ---------- */

  function clockFormatter() {
    var locale = currentLang === "ar" ? "ar-SA-u-ca-gregory-nu-latn" : "en-US";
    try {
      return new Intl.DateTimeFormat(locale, {
        hour: "numeric",
        minute: "2-digit",
        hour12: true,
        timeZone: TIME_ZONE
      });
    } catch (e) {
      return null;
    }
  }

  function renderClock() {
    var el = getEl("clock-time");
    if (!el) {
      return;
    }
    var fmt = clockFormatter();
    if (!fmt) {
      return;
    }
    try {
      el.textContent = fmt.format(new Date());
    } catch (e) { /* keep placeholder */ }
  }

  /* ---------- weather (open-meteo, no API key) ---------- */

  function weatherKeyForCode(code) {
    if (code <= 1) return "weatherClear";
    if (code === 2) return "weatherPartly";
    if (code === 3) return "weatherCloudy";
    if (code === 45 || code === 48) return "weatherFog";
    if ([51, 53, 55, 56, 57, 61, 66, 80, 81].indexOf(code) !== -1) return "weatherLightRain";
    if ([63, 65, 67, 82].indexOf(code) !== -1) return "weatherRain";
    if ([71, 73, 75, 77, 85, 86].indexOf(code) !== -1) return "weatherSnow";
    if (code >= 95) return "weatherStorm";
    return "weatherCloudy";
  }

  function renderWeather() {
    var valueEl = getEl("weather-value");
    if (!valueEl || !weatherData) {
      return;
    }
    var t = window.TRANSLATIONS[currentLang];
    var label = t[weatherKeyForCode(weatherData.weather_code)] || "";
    var temp = Math.round(weatherData.temperature_2m);
    valueEl.textContent = label + " · " + temp + "°C";
  }

  function fetchWeather() {
    var wrap = getEl("weather-wrap");
    if (!wrap || !("fetch" in window)) {
      return;
    }
    var controller = window.AbortController ? new AbortController() : null;
    var timer = setTimeout(function () {
      if (controller) {
        controller.abort();
      }
    }, 6000);

    var url = "https://api.open-meteo.com/v1/forecast?latitude=26.4207&longitude=50.0888&current=temperature_2m,weather_code&timezone=Asia%2FRiyadh";

    fetch(url, controller ? { signal: controller.signal } : {})
      .then(function (res) {
        if (!res.ok) {
          throw new Error("weather unavailable");
        }
        return res.json();
      })
      .then(function (data) {
        if (data && data.current) {
          weatherData = data.current;
          renderWeather();
          wrap.hidden = false;
        }
      })
      .catch(function () {
        /* Weather is a progressive enhancement — stay hidden on failure. */
      })
      .finally(function () {
        clearTimeout(timer);
      });
  }

  /* ---------- clipboard + toasts ---------- */

  function copyText(text) {
    function legacyCopy() {
      return new Promise(function (resolve, reject) {
        var ta = document.createElement("textarea");
        ta.value = text;
        ta.setAttribute("readonly", "");
        ta.style.position = "fixed";
        ta.style.opacity = "0";
        document.body.appendChild(ta);
        ta.select();
        try {
          var ok = document.execCommand("copy");
          document.body.removeChild(ta);
          if (ok) {
            resolve();
          } else {
            reject(new Error("execCommand copy failed"));
          }
        } catch (err) {
          document.body.removeChild(ta);
          reject(err);
        }
      });
    }

    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text).catch(function () {
        return legacyCopy();
      });
    }
    return legacyCopy();
  }

  function showToast(message, isError) {
    var toast = getEl("toast");
    if (!toast) {
      return;
    }
    toast.textContent = message;
    toast.classList.toggle("is-error", !!isError);
    toast.classList.add("is-visible");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () {
      toast.classList.remove("is-visible");
    }, 2600);
  }

  function bindCopyButtons() {
    document.querySelectorAll(".copy-btn").forEach(function (btn) {
      btn.addEventListener("click", function () {
        var value = btn.getAttribute("data-copy");
        if (!value) {
          return;
        }
        var t = window.TRANSLATIONS[currentLang];
        var toastKey = btn.getAttribute("data-toast-key") || "toastCopiedAddress";
        copyText(value)
          .then(function () {
            showToast(t[toastKey]);
          })
          .catch(function () {
            showToast(t.toastCopyError, true);
          });
      });
    });
  }

  /* ---------- facility open/closed status ---------- */

  function riyadhMinutes() {
    try {
      var parts = new Intl.DateTimeFormat("en-GB", {
        hour: "numeric",
        minute: "numeric",
        hourCycle: "h23",
        timeZone: TIME_ZONE
      }).formatToParts(new Date());
      var hour = 0;
      var minute = 0;
      parts.forEach(function (p) {
        if (p.type === "hour") hour = parseInt(p.value, 10);
        if (p.type === "minute") minute = parseInt(p.value, 10);
      });
      return hour * 60 + minute;
    } catch (e) {
      return null;
    }
  }

  var FACILITY_RULES = {
    pool: { kind: "hours", open: 6 * 60, close: 23 * 60 },
    gym: { kind: "always" },
    starbucks: { kind: "hours", open: 8 * 60, close: 22 * 60 },
    restaurant: {
      kind: "windows",
      windows: [[6 * 60, 10 * 60], [11 * 60, 15 * 60], [19 * 60, 23 * 60]]
    },
    reception: { kind: "always" }
  };

  function facilityState(rule, minutes) {
    if (rule.kind === "always") {
      return "is-247";
    }
    if (minutes == null) {
      return null;
    }
    if (rule.kind === "hours") {
      return minutes >= rule.open && minutes < rule.close ? "is-open" : "is-closed";
    }
    if (rule.kind === "windows") {
      var open = rule.windows.some(function (w) {
        return minutes >= w[0] && minutes < w[1];
      });
      return open ? "is-open" : "is-closed";
    }
    return null;
  }

  function renderStatuses() {
    var t = window.TRANSLATIONS[currentLang];
    var minutes = riyadhMinutes();

    document.querySelectorAll("[data-status]").forEach(function (pill) {
      var name = pill.getAttribute("data-status");
      var rule = FACILITY_RULES[name];
      if (!rule) {
        return;
      }
      var state = facilityState(rule, minutes);
      if (!state) {
        return;
      }
      pill.classList.remove("is-open", "is-closed", "is-247");
      pill.classList.add(state);
      if (state === "is-247") {
        pill.textContent = t.status247;
      } else if (state === "is-open") {
        pill.textContent = t.statusOpen;
      } else {
        pill.textContent = t.statusClosed;
      }
      pill.hidden = false;
    });
  }

  /* ---------- navigation & scroll helpers ---------- */

  function bindBackToTop() {
    var btn = getEl("back-to-top");
    if (!btn) {
      return;
    }
    window.addEventListener(
      "scroll",
      function () {
        btn.hidden = window.scrollY < 640;
      },
      { passive: true }
    );
    btn.addEventListener("click", function () {
      var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
      window.scrollTo({ top: 0, behavior: reduce ? "auto" : "smooth" });
    });
  }

  function bindScrollSpy() {
    if (!("IntersectionObserver" in window)) {
      return;
    }
    var targets = ["top", "wifi", "dining", "location"];
    var items = Array.prototype.slice.call(document.querySelectorAll(".bottom-nav-item"));

    function setActive(key) {
      items.forEach(function (item) {
        item.classList.toggle("is-active", item.getAttribute("data-nav") === key);
      });
    }

    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            var id = entry.target.id;
            setActive(id === "top" ? "home" : id);
          }
        });
      },
      { rootMargin: "-38% 0px -55% 0px", threshold: 0 }
    );

    targets.forEach(function (id) {
      var el = getEl(id);
      if (el) {
        observer.observe(el);
      }
    });
  }

  function bindReveal() {
    var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reduce || !("IntersectionObserver" in window)) {
      return;
    }
    var cards = document.querySelectorAll(".card");
    cards.forEach(function (card) {
      card.classList.add("reveal");
    });
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.04, rootMargin: "0px 0px -30px 0px" }
    );
    cards.forEach(function (card) {
      observer.observe(card);
    });
  }

  function registerServiceWorker() {
    if (!("serviceWorker" in navigator) || location.protocol.indexOf("http") !== 0) {
      return;
    }
    window.addEventListener("load", function () {
      navigator.serviceWorker.register("sw.js").catch(function () { /* offline feature is optional */ });
    });
  }

  /* ---------- init ---------- */

  function init() {
    var toggleTop = getEl("lang-toggle");
    var toggleFooter = getEl("lang-toggle-footer");
    if (toggleTop) {
      toggleTop.addEventListener("click", toggleLang);
    }
    if (toggleFooter) {
      toggleFooter.addEventListener("click", toggleLang);
    }

    bindCopyButtons();
    bindBackToTop();
    bindScrollSpy();
    bindReveal();
    registerServiceWorker();

    applyLang(detectInitialLang());

    renderClock();
    setInterval(renderClock, 20000);

    fetchWeather();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
