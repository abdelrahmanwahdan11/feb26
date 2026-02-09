const translations = {
  ar: {
    brand_title: "نيون شيت للذكاء الاصطناعي",
    brand_tagline: "مساحة عمل شبيهة بإكسل مدعومة بذكاء Gemini",
    toggle_language: "عربي / إنجليزي",
    login: "تسجيل الدخول",
    splash_title: "مرحبا بك في نيون شيت",
    splash_desc: "كون جداول البيانات ثنائي اللغة مع ذكاء Gemini.",
    start: "ابدأ",
    onboard_1_title: "سحر فوري",
    onboard_1_desc: "حمّل ملفات إكسل ودع Gemini يلخص ويحرر ويصور.",
    onboard_2_title: "تقارير ذكية",
    onboard_2_desc: "اطلب لوحات مؤشرات وتوقعات وتوصيات.",
    onboard_3_title: "تجربة ثنائية اللغة",
    onboard_3_desc: "بدّل بين العربية والإنجليزية بلمسة واحدة.",
    skip: "تخطي",
    next: "التالي",
    signup: "إنشاء حساب",
    guest: "ضيف",
    login_title: "أهلا بعودتك",
    signup_title: "أنشئ مساحة عملك",
    guest_title: "جرب كضيف",
    guest_desc: "استكشف ذكاء الجداول دون حفظ البيانات.",
    email: "البريد الإلكتروني",
    password: "كلمة المرور",
    full_name: "الاسم الكامل",
    enter: "دخول",
    create: "إنشاء الحساب",
    enter_guest: "الدخول كضيف",
    workspace: "المساحة",
    ai_center: "مركز الذكاء",
    reports: "التقارير",
    search: "البحث",
    settings: "الإعدادات",
    workspace_title: "عالم إكسل",
    workspace_desc: "استورد أي ملف يقرأه إكسل وشاهده ينبض بالحياة.",
    upload: "رفع ملف",
    export: "تصدير",
    ai_center_title: "مركز أوامر Gemini",
    ai_center_desc: "صف ما تحتاجه وسيتولى Gemini التنفيذ.",
    run_ai: "تشغيل مع Gemini",
    reports_title: "تقارير وتحليلات",
    reports_desc: "أنشئ تقارير وملخصات ولوحات متابعة من بياناتك.",
    report_kpi: "لوحة مؤشرات",
    report_kpi_desc: "ينشئ Gemini الرسوم والتحليلات تلقائيا.",
    report_forecast: "توقعات",
    report_forecast_desc: "تنبؤ بالاتجاهات ورصد الشذوذ.",
    report_story: "تقرير قصصي",
    report_story_desc: "تحويل الجدول إلى تقرير احترافي.",
    generate: "إنشاء",
    search_title: "محرك البحث المدمج",
    search_desc: "ابحث في الويب من داخل مساحة العمل.",
    settings_title: "إعدادات ذكية",
    settings_desc: "اطلب من Gemini ضبط الواجهة والتصدير.",
    apply: "تطبيق مع Gemini",
    loading: "جارٍ تحميل مساحة العمل..."
  },
  en: {
    brand_title: "Neon Sheet AI",
    brand_tagline: "Smart Excel-like workspace powered by Gemini",
    toggle_language: "AR / EN",
    login: "Login",
    splash_title: "Welcome to Neon Sheet",
    splash_desc: "A bilingual, animated spreadsheet universe with Gemini intelligence.",
    start: "Start",
    onboard_1_title: "Instant Magic",
    onboard_1_desc: "Load Excel files and let Gemini summarize, edit, and visualize.",
    onboard_2_title: "AI Reports",
    onboard_2_desc: "Ask for KPI dashboards, forecasts, and smart recommendations.",
    onboard_3_title: "Bilingual Flow",
    onboard_3_desc: "Switch between Arabic and English with a single tap.",
    skip: "Skip",
    next: "Next",
    signup: "Create Account",
    guest: "Guest",
    login_title: "Welcome back",
    signup_title: "Create your workspace",
    guest_title: "Try as guest",
    guest_desc: "Explore the AI spreadsheet without saving anything.",
    email: "Email",
    password: "Password",
    full_name: "Full Name",
    enter: "Enter",
    create: "Create Account",
    enter_guest: "Enter as guest",
    workspace: "Workspace",
    ai_center: "AI Center",
    reports: "Reports",
    search: "Search",
    settings: "Settings",
    workspace_title: "Excel Universe",
    workspace_desc: "Import any Excel-compatible file and watch it animate.",
    upload: "Upload",
    export: "Export",
    ai_center_title: "Gemini Command Center",
    ai_center_desc: "Describe what you need. Gemini takes the wheel.",
    run_ai: "Run with Gemini",
    reports_title: "AI Reports & Analytics",
    reports_desc: "Generate reports, summaries, and dashboards from your data.",
    report_kpi: "KPI Dashboard",
    report_kpi_desc: "Gemini crafts charts and insights automatically.",
    report_forecast: "Forecast",
    report_forecast_desc: "Predict trends and highlight anomalies.",
    report_story: "Narrative Report",
    report_story_desc: "Turn your spreadsheet into a polished report.",
    generate: "Generate",
    search_title: "Built-in Search",
    search_desc: "Search the web from inside your workspace.",
    settings_title: "Smart Settings",
    settings_desc: "Ask Gemini to adjust preferences, themes, and exports.",
    apply: "Apply with Gemini",
    loading: "Loading your workspace..."
  }
};

const state = {
  lang: "ar",
  onboardingStep: 1,
  sheetData: [],
  geminiKey: "AIzaSyAO5VBHhruRHCVcRcSX2cWTW1wJ8utZGGs",
  searchApiKey: "AIzaSyA0-dxnZUucBiuwe6eDooqEFGTWGYMlgdo"
};

const sections = {
  splash: document.getElementById("splash"),
  onboarding: document.getElementById("onboarding"),
  auth: document.getElementById("auth"),
  dashboard: document.getElementById("dashboard")
};

const loading = document.getElementById("loading");
const langToggle = document.getElementById("langToggle");
const sheetGrid = document.getElementById("sheetGrid");
const fileInput = document.getElementById("fileInput");
const exportButton = document.getElementById("exportButton");

const aiRun = document.getElementById("aiRun");
const aiOutput = document.getElementById("aiOutput");
const aiPrompt = document.getElementById("aiPrompt");
const reportOutput = document.getElementById("reportOutput");
const settingsRun = document.getElementById("settingsRun");
const settingsPrompt = document.getElementById("settingsPrompt");
const settingsOutput = document.getElementById("settingsOutput");

const updateTranslations = () => {
  document.documentElement.lang = state.lang;
  document.documentElement.dir = state.lang === "ar" ? "rtl" : "ltr";
  document.querySelectorAll("[data-i18n]").forEach((el) => {
    const key = el.getAttribute("data-i18n");
    const translation = translations[state.lang][key];
    if (translation) {
      el.textContent = translation;
    }
  });
};

const showSection = (name) => {
  Object.values(sections).forEach((section) => section.classList.add("hidden"));
  sections[name].classList.remove("hidden");
};

const showLoading = (active) => {
  loading.classList.toggle("active", active);
};

const animateSplash = () => {
  gsap.from(".splash-content > *", { opacity: 0, y: 20, stagger: 0.2, duration: 0.8 });
};

const setOnboardingStep = (step) => {
  state.onboardingStep = step;
  document.querySelectorAll(".step").forEach((item) => {
    item.classList.toggle("active", Number(item.dataset.step) === step);
  });
};

const renderSheet = () => {
  sheetGrid.innerHTML = "";
  const rows = state.sheetData.length ? state.sheetData : createSampleData();
  rows.slice(0, 24).forEach((row) => {
    row.slice(0, 8).forEach((cell) => {
      const div = document.createElement("div");
      div.className = "sheet-cell";
      div.textContent = cell ?? "";
      sheetGrid.appendChild(div);
    });
  });
};

const createSampleData = () => {
  return Array.from({ length: 12 }, (_, rowIndex) =>
    Array.from({ length: 8 }, (_, colIndex) =>
      `${state.lang === "ar" ? "خلية" : "Cell"} ${rowIndex + 1}-${colIndex + 1}`
    )
  );
};

const readFile = (file) => {
  const reader = new FileReader();
  reader.onload = (event) => {
    const data = new Uint8Array(event.target.result);
    const workbook = XLSX.read(data, { type: "array" });
    const firstSheet = workbook.Sheets[workbook.SheetNames[0]];
    const jsonData = XLSX.utils.sheet_to_json(firstSheet, { header: 1 });
    state.sheetData = jsonData;
    renderSheet();
  };
  reader.readAsArrayBuffer(file);
};

const exportFile = () => {
  const worksheet = XLSX.utils.aoa_to_sheet(state.sheetData.length ? state.sheetData : createSampleData());
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, "NeonSheet");
  XLSX.writeFile(workbook, "neon-sheet.xlsx");
};

const callGemini = async (prompt) => {
  showLoading(true);
  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${state.geminiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }]
        })
      }
    );
    if (!response.ok) {
      throw new Error(`Gemini error: ${response.status}`);
    }
    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || "";
  } catch (error) {
    return state.lang === "ar"
      ? "تعذر الاتصال بـ Gemini حاليا. تم تجهيز الطلب وسيتم تشغيله عند الربط الخلفي."
      : "Unable to reach Gemini now. The request is queued until backend wiring.";
  } finally {
    showLoading(false);
  }
};

const runReport = async (type) => {
  const prompts = {
    kpi: state.lang === "ar" ? "حلل مؤشرات الأداء الرئيسية" : "Analyze KPI dashboard",
    forecast: state.lang === "ar" ? "توقع الاتجاهات القادمة" : "Forecast upcoming trends",
    story: state.lang === "ar" ? "اكتب تقريرا سرديا للبيانات" : "Write a narrative report"
  };
  reportOutput.textContent = state.lang === "ar" ? "جارٍ التوليد..." : "Generating...";
  const result = await callGemini(prompts[type]);
  reportOutput.textContent = result;
};

const initEvents = () => {
  langToggle.addEventListener("click", () => {
    state.lang = state.lang === "ar" ? "en" : "ar";
    updateTranslations();
    renderSheet();
  });

  document.querySelectorAll("[data-action='start-onboarding']").forEach((btn) => {
    btn.addEventListener("click", () => {
      showSection("onboarding");
      setOnboardingStep(1);
    });
  });

  document.querySelectorAll("[data-action='skip-onboarding']").forEach((btn) => {
    btn.addEventListener("click", () => showSection("auth"));
  });

  document.querySelectorAll("[data-action='next-onboarding']").forEach((btn) => {
    btn.addEventListener("click", () => {
      const nextStep = state.onboardingStep + 1;
      if (nextStep > 3) {
        showSection("auth");
      } else {
        setOnboardingStep(nextStep);
      }
    });
  });

  document.querySelectorAll(".tab").forEach((tab) => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".tab").forEach((item) => item.classList.remove("active"));
      tab.classList.add("active");
      document.querySelectorAll(".auth-panel").forEach((panel) => panel.classList.add("hidden"));
      document.getElementById(tab.dataset.auth).classList.remove("hidden");
    });
  });

  document.querySelectorAll("[data-action='toggle-password']").forEach((btn) => {
    btn.addEventListener("click", () => {
      const target = document.getElementById(btn.dataset.target);
      target.type = target.type === "password" ? "text" : "password";
      btn.querySelector("i").classList.toggle("fa-eye");
      btn.querySelector("i").classList.toggle("fa-eye-slash");
    });
  });

  document.querySelectorAll("[data-action='enter-app']").forEach((btn) => {
    btn.addEventListener("click", () => {
      showLoading(true);
      setTimeout(() => {
        showSection("dashboard");
        showLoading(false);
        renderSheet();
        gsap.from(".sidebar-button", { x: -20, opacity: 0, stagger: 0.1, duration: 0.5 });
      }, 1200);
    });
  });

  document.querySelectorAll(".sidebar-button").forEach((button) => {
    button.addEventListener("click", () => {
      document.querySelectorAll(".sidebar-button").forEach((item) => item.classList.remove("active"));
      button.classList.add("active");
      document.querySelectorAll(".panel-section").forEach((panel) => panel.classList.add("hidden"));
      document.getElementById(button.dataset.panel).classList.remove("hidden");
      gsap.from(`#${button.dataset.panel}`, { opacity: 0, y: 10, duration: 0.4 });
    });
  });

  fileInput.addEventListener("change", (event) => {
    const file = event.target.files[0];
    if (file) {
      readFile(file);
    }
  });

  exportButton.addEventListener("click", exportFile);

  aiRun.addEventListener("click", async () => {
    const prompt = aiPrompt.value.trim();
    if (!prompt) return;
    aiOutput.textContent = state.lang === "ar" ? "جارٍ التنفيذ..." : "Running...";
    const response = await callGemini(prompt);
    aiOutput.textContent = response;
  });

  document.querySelectorAll("[data-action='run-report']").forEach((button) => {
    button.addEventListener("click", () => runReport(button.dataset.report));
  });

  settingsRun.addEventListener("click", async () => {
    const prompt = settingsPrompt.value.trim();
    if (!prompt) return;
    settingsOutput.textContent = state.lang === "ar" ? "جارٍ التطبيق..." : "Applying...";
    const response = await callGemini(prompt);
    settingsOutput.textContent = response;
  });

  document.querySelectorAll("[data-action='show-auth']").forEach((btn) => {
    btn.addEventListener("click", () => {
      showSection("auth");
      document.getElementById(btn.dataset.target).classList.remove("hidden");
    });
  });
};

updateTranslations();
renderSheet();
animateSplash();
initEvents();
