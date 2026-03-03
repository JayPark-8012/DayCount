import { useState } from "react";

const CATEGORIES = [
  { id: "all", label: "전체", emoji: "✨" },
  { id: "anniversary", label: "기념일", emoji: "🎉" },
  { id: "couple", label: "커플", emoji: "💕" },
  { id: "exam", label: "시험", emoji: "📚" },
  { id: "travel", label: "여행", emoji: "✈️" },
  { id: "birthday", label: "생일", emoji: "🎂" },
  { id: "baby", label: "육아", emoji: "👶" },
];

const THEMES = {
  cloud: { bg: "linear-gradient(135deg, #F0F0FF, #E0E0FF)", text: "#2D2D5F", accent: "#6C63FF", pattern: "circles" },
  sunset: { bg: "linear-gradient(135deg, #FFF5ED, #FFE0CC)", text: "#8B4513", accent: "#FF6B3D", pattern: "waves" },
  ocean: { bg: "linear-gradient(135deg, #E6F5FF, #B8DFFF)", text: "#1A5276", accent: "#2E86DE", pattern: "waves" },
  forest: { bg: "linear-gradient(135deg, #E8F5E9, #C0E0C0)", text: "#1B5E20", accent: "#43A047", pattern: "leaves" },
  lavender: { bg: "linear-gradient(135deg, #F3E5F5, #DCC0E8)", text: "#4A148C", accent: "#9C27B0", pattern: "circles" },
  midnight: { bg: "linear-gradient(135deg, #1A1A2E, #16213E)", text: "#E8E8FF", accent: "#6C63FF", pattern: "stars", isPro: true },
  cherry: { bg: "linear-gradient(135deg, #C62828, #E53935)", text: "#FFFFFF", accent: "#FFCDD2", pattern: "petals", isPro: true },
  aurora: { bg: "linear-gradient(135deg, #0F2027, #2C5364)", text: "#43E8D8", accent: "#43E8D8", pattern: "aurora", isPro: true },
};

const SAMPLE_DDAYS = [
  { id: 1, title: "Our Anniversary", date: "2024-06-15", category: "couple", emoji: "💕", theme: "lavender", isFavorite: true },
  { id: 2, title: "Final Exam", date: "2026-06-20", category: "exam", emoji: "📚", theme: "ocean" },
  { id: 3, title: "Tokyo Trip", date: "2026-04-15", category: "travel", emoji: "✈️", theme: "sunset" },
  { id: 4, title: "Project Launch", date: "2026-03-30", category: "anniversary", emoji: "🚀", theme: "cloud" },
  { id: 5, title: "Baby's Birthday", date: "2025-09-10", category: "baby", emoji: "👶", theme: "forest" },
  { id: 6, title: "Mom's Birthday", date: "2026-05-12", category: "birthday", emoji: "🎂", theme: "cherry" },
];

function getDaysFromNow(dateStr) {
  const now = new Date(2026, 2, 1);
  const target = new Date(dateStr);
  return Math.ceil((target - now) / (1000 * 60 * 60 * 24));
}

function PatternSVG({ type, color, opacity = 0.08 }) {
  const c = color || "#6C63FF";
  const s = { position: "absolute", right: -20, top: -20, opacity, pointerEvents: "none" };
  if (type === "circles") return <svg style={{ ...s, width: 160, height: 160 }} viewBox="0 0 160 160"><circle cx="80" cy="80" r="70" fill={c} /><circle cx="130" cy="130" r="35" fill={c} opacity=".4" /></svg>;
  if (type === "waves") return <svg style={{ ...s, right: -10, bottom: -10, top: "auto", width: 180, height: 90 }} viewBox="0 0 180 90"><path d="M0,45 Q45,0 90,45 T180,45 L180,90 L0,90Z" fill={c} /><path d="M0,60 Q45,30 90,60 T180,60 L180,90 L0,90Z" fill={c} opacity=".4" /></svg>;
  if (type === "leaves") return <svg style={{ ...s, width: 140, height: 140 }} viewBox="0 0 140 140"><ellipse cx="90" cy="35" rx="35" ry="16" transform="rotate(30 90 35)" fill={c} /><ellipse cx="108" cy="70" rx="28" ry="13" transform="rotate(-20 108 70)" fill={c} opacity=".5" /><ellipse cx="78" cy="95" rx="22" ry="11" transform="rotate(45 78 95)" fill={c} opacity=".3" /></svg>;
  if (type === "stars") return <svg style={{ ...s, width: 160, height: 120, opacity: opacity * 2.5 }} viewBox="0 0 160 120">{[[22,22,2.5],[55,38,3.5],[85,18,2],[118,45,3],[38,68,1.8],[95,78,2.5],[128,28,1.8],[65,90,2.2]].map(([x,y,r],i)=><circle key={i} cx={x} cy={y} r={r} fill={c}/>)}</svg>;
  if (type === "petals") return <svg style={{ ...s, width: 140, height: 140 }} viewBox="0 0 140 140">{[0,60,120,180,240,300].map((a,i)=><ellipse key={i} cx="70" cy="70" rx="13" ry="32" fill={c} transform={`rotate(${a} 70 70) translate(0 -28)`} opacity={.5+i*.06}/>)}</svg>;
  if (type === "aurora") return <svg style={{ position: "absolute", left: 0, top: 0, opacity: opacity * 2, width: "100%", height: "100%", pointerEvents: "none" }} viewBox="0 0 300 120" preserveAspectRatio="none"><path d="M0,80 Q75,20 150,60 T300,40 L300,120 L0,120Z" fill={c} opacity=".3"/><path d="M0,95 Q75,55 150,85 T300,65 L300,120 L0,120Z" fill={c} opacity=".2"/></svg>;
  return null;
}

// Glass helper
const glass = (dark, blur = 12) => ({
  background: dark ? "rgba(26,26,48,0.6)" : "rgba(255,255,255,0.55)",
  backdropFilter: `blur(${blur}px)`,
  WebkitBackdropFilter: `blur(${blur}px)`,
  border: dark ? "1px solid rgba(255,255,255,0.08)" : "1px solid rgba(255,255,255,0.7)",
});

// ============ HOME ============
function HomeScreen({ onNavigate, darkMode }) {
  const [selectedCategory, setSelectedCategory] = useState("all");
  const [viewMode, setViewMode] = useState("list");
  const [touchStart, setTouchStart] = useState(null);
  const [pressedCard, setPressedCard] = useState(null);

  const filtered = selectedCategory === "all" ? SAMPLE_DDAYS : SAMPLE_DDAYS.filter((d) => d.category === selectedCategory);
  const sorted = [...filtered].sort((a, b) => Math.abs(getDaysFromNow(a.date)) - Math.abs(getDaysFromNow(b.date)));
  const hero = sorted[0];
  const rest = sorted.slice(1);
  const heroDays = getDaysFromNow(hero.date);
  const heroTheme = THEMES[hero.theme];

  const bg = darkMode ? "#0A0A16" : "#F6F6FC";
  const textPrimary = darkMode ? "#E8E8FF" : "#1A1A2E";
  const textSecondary = darkMode ? "#6B6B8D" : "#9090A8";
  const chipBg = darkMode ? "rgba(40,40,72,0.5)" : "rgba(240,240,248,0.8)";

  const handleTouchStart = (e) => setTouchStart(e.touches[0].clientX);
  const handleTouchEnd = (e) => {
    if (touchStart === null) return;
    const diff = touchStart - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 60) {
      if (diff > 0 && viewMode === "list") setViewMode("timeline");
      if (diff < 0 && viewMode === "timeline") setViewMode("list");
    }
    setTouchStart(null);
  };

  const timelineSorted = [...filtered].sort((a, b) => getDaysFromNow(a.date) - getDaysFromNow(b.date));

  return (
    <div style={{ background: bg, minHeight: "100%", paddingBottom: 110 }} onTouchStart={handleTouchStart} onTouchEnd={handleTouchEnd}>

      {/* App Bar */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "20px 24px 12px" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: "linear-gradient(135deg, #6C63FF, #FF6B8A)", display: "flex", alignItems: "center", justifyContent: "center", color: "#fff", fontWeight: 800, fontSize: 15, fontFamily: "'Outfit',sans-serif", boxShadow: "0 4px 16px rgba(108,99,255,0.35)" }}>D</div>
          <span style={{ fontSize: 22, fontWeight: 800, color: textPrimary, fontFamily: "'Outfit',sans-serif", letterSpacing: -0.8 }}>DayCount</span>
        </div>
        <button onClick={() => onNavigate("settings")} style={{ width: 40, height: 40, borderRadius: 12, ...glass(darkMode, 10), cursor: "pointer", fontSize: 17, display: "flex", alignItems: "center", justifyContent: "center", transition: "transform 0.15s" }} onMouseDown={e => e.currentTarget.style.transform = "scale(0.92)"} onMouseUp={e => e.currentTarget.style.transform = "scale(1)"}>⚙️</button>
      </div>

      {/* Segment Tab — Glass */}
      <div style={{ padding: "4px 24px 8px" }}>
        <div style={{ display: "flex", borderRadius: 14, padding: 4, ...glass(darkMode, 16) }}>
          {[{ id: "list", label: "📋 리스트" }, { id: "timeline", label: "📊 타임라인" }].map((tab) => (
            <button key={tab.id} onClick={() => setViewMode(tab.id)} style={{
              flex: 1, padding: "11px 0", borderRadius: 11, border: "none",
              background: viewMode === tab.id ? (darkMode ? "rgba(108,99,255,0.25)" : "rgba(255,255,255,0.9)") : "transparent",
              color: viewMode === tab.id ? (darkMode ? "#A5A0FF" : "#6C63FF") : textSecondary,
              fontSize: 14, fontWeight: 700, cursor: "pointer", fontFamily: "'Outfit',sans-serif",
              transition: "all 0.3s cubic-bezier(0.34,1.56,0.64,1)",
              boxShadow: viewMode === tab.id ? (darkMode ? "0 2px 12px rgba(108,99,255,0.2)" : "0 2px 12px rgba(0,0,0,0.06)") : "none",
              transform: viewMode === tab.id ? "scale(1)" : "scale(0.97)",
            }}>{tab.label}</button>
          ))}
        </div>
      </div>

      {/* Category Chips */}
      <div style={{ display: "flex", gap: 10, padding: "12px 24px 12px", overflowX: "auto" }}>
        {CATEGORIES.map((cat) => {
          const active = selectedCategory === cat.id;
          return (
            <button key={cat.id} onClick={() => setSelectedCategory(cat.id)} style={{
              padding: "9px 16px", borderRadius: 22, border: "none",
              background: active ? "linear-gradient(135deg, #6C63FF, #8B5CF6)" : chipBg,
              color: active ? "#fff" : textSecondary,
              fontSize: 13, fontWeight: 600, cursor: "pointer", whiteSpace: "nowrap",
              fontFamily: "'Outfit',sans-serif",
              transition: "all 0.3s cubic-bezier(0.34,1.56,0.64,1)",
              transform: active ? "scale(1.05)" : "scale(1)",
              boxShadow: active ? "0 4px 14px rgba(108,99,255,0.3)" : "none",
            }}>{cat.emoji} {cat.label}</button>
          );
        })}
      </div>

      {/* ========== LIST VIEW ========== */}
      {viewMode === "list" && (
        <div style={{ animation: "fadeIn 0.35s ease-out" }}>
          {/* Hero Card — Elevated + Glass overlay */}
          <div style={{ padding: "8px 24px 0" }}>
            <div onClick={() => onNavigate("detail", hero)}
              onMouseDown={() => setPressedCard("hero")} onMouseUp={() => setPressedCard(null)} onMouseLeave={() => setPressedCard(null)}
              style={{
                background: heroTheme.bg, borderRadius: 28, padding: "32px 28px",
                position: "relative", overflow: "hidden", cursor: "pointer", minHeight: 180,
                boxShadow: darkMode ? "0 12px 40px rgba(0,0,0,0.4)" : "0 12px 40px rgba(108,99,255,0.12)",
                transition: "transform 0.2s cubic-bezier(0.34,1.56,0.64,1), box-shadow 0.2s",
                transform: pressedCard === "hero" ? "scale(0.97)" : "scale(1)",
              }}>
              <PatternSVG type={heroTheme.pattern} color={heroTheme.accent} opacity={0.12} />
              {/* Glass accent bar */}
              <div style={{ position: "absolute", top: 0, left: 0, right: 0, height: 3, background: `linear-gradient(90deg, ${heroTheme.accent}, transparent)`, borderRadius: "28px 28px 0 0" }} />
              <div style={{ position: "relative", zIndex: 1 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 6 }}>
                  <span style={{ fontSize: 32 }}>{hero.emoji}</span>
                  {hero.isFavorite && <span style={{ fontSize: 14, opacity: 0.6 }}>⭐</span>}
                </div>
                <div style={{ fontSize: 20, fontWeight: 700, color: heroTheme.text, fontFamily: "'Outfit',sans-serif", marginBottom: 12, letterSpacing: -0.3 }}>{hero.title}</div>
                <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
                  <span style={{ fontSize: 60, fontWeight: 800, color: heroTheme.accent, fontFamily: "'Outfit',sans-serif", letterSpacing: -3, lineHeight: 1 }}>
                    {heroDays < 0 ? `+${Math.abs(heroDays)}` : heroDays === 0 ? "D-Day!" : heroDays}
                  </span>
                  {heroDays !== 0 && <span style={{ fontSize: 13, fontWeight: 600, color: heroTheme.text, opacity: 0.4, fontFamily: "'Outfit',sans-serif" }}>{heroDays < 0 ? "days ago" : "days left"}</span>}
                </div>
                <div style={{ fontSize: 11, color: heroTheme.text, opacity: 0.35, marginTop: 10, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>{hero.date}</div>
              </div>
            </div>
          </div>

          {/* List Header */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "20px 24px 12px" }}>
            <span style={{ fontSize: 12, color: textSecondary, fontFamily: "'Outfit',sans-serif", fontWeight: 500, letterSpacing: 0.5, textTransform: "uppercase" }}>{rest.length + 1}개의 D-Day</span>
            <button style={{ background: "none", border: "none", fontSize: 12, color: "#6C63FF", fontWeight: 600, cursor: "pointer", fontFamily: "'Outfit',sans-serif" }}>날짜 가까운순 ▾</button>
          </div>

          {/* D-Day List Cards */}
          <div style={{ padding: "0 24px", display: "flex", flexDirection: "column", gap: 16 }}>
            {rest.map((dday, idx) => {
              const days = getDaysFromNow(dday.date);
              const theme = THEMES[dday.theme];
              return (
                <div key={dday.id} onClick={() => onNavigate("detail", dday)}
                  onMouseDown={() => setPressedCard(dday.id)} onMouseUp={() => setPressedCard(null)} onMouseLeave={() => setPressedCard(null)}
                  style={{
                    background: theme.bg, borderRadius: 22, padding: "20px 22px",
                    position: "relative", overflow: "hidden", cursor: "pointer",
                    display: "flex", justifyContent: "space-between", alignItems: "center",
                    boxShadow: darkMode ? "0 6px 24px rgba(0,0,0,0.25)" : "0 4px 20px rgba(0,0,0,0.05)",
                    animation: `fadeSlideIn 0.45s ease-out ${idx * 0.07}s both`,
                    transition: "transform 0.2s cubic-bezier(0.34,1.56,0.64,1)",
                    transform: pressedCard === dday.id ? "scale(0.97)" : "scale(1)",
                  }}>
                  <PatternSVG type={theme.pattern} color={theme.accent} opacity={0.07} />
                  <div style={{ position: "relative", zIndex: 1 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <span style={{ fontSize: 24 }}>{dday.emoji}</span>
                      <span style={{ fontSize: 16, fontWeight: 700, color: theme.text, fontFamily: "'Outfit',sans-serif" }}>{dday.title}</span>
                      {dday.isFavorite && <span style={{ fontSize: 11 }}>⭐</span>}
                    </div>
                    <div style={{ fontSize: 11, color: theme.text, opacity: 0.35, marginTop: 5, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>{dday.date}</div>
                  </div>
                  <div style={{ textAlign: "right", position: "relative", zIndex: 1 }}>
                    <div style={{ fontSize: 32, fontWeight: 800, color: theme.accent, fontFamily: "'Outfit',sans-serif", letterSpacing: -1.5, lineHeight: 1 }}>
                      {days < 0 ? `+${Math.abs(days)}` : days}
                    </div>
                    <div style={{ fontSize: 10, color: theme.text, opacity: 0.35, fontFamily: "'Outfit',sans-serif", marginTop: 3, fontWeight: 500 }}>{days < 0 ? "days ago" : "days left"}</div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* ========== TIMELINE VIEW ========== */}
      {viewMode === "timeline" && (
        <div style={{ padding: "20px 24px", animation: "fadeIn 0.35s ease-out" }}>
          <div style={{ position: "relative", paddingLeft: 36 }}>
            <div style={{ position: "absolute", left: 13, top: 0, bottom: 0, width: 2, background: darkMode ? "linear-gradient(180deg, #6C63FF, #FF6B8A44, transparent)" : "linear-gradient(180deg, #6C63FF33, #FF6B8A22, transparent)", borderRadius: 1 }} />
            {timelineSorted.map((dday, idx) => {
              const days = getDaysFromNow(dday.date);
              const theme = THEMES[dday.theme];
              const isPast = days < 0;
              const isToday = days === 0;
              return (
                <div key={dday.id} style={{ position: "relative", marginBottom: 20 }}>
                  {/* Node */}
                  <div style={{
                    position: "absolute", left: -36, top: "50%", transform: "translateY(-50%)", zIndex: 2,
                    width: isToday ? 28 : 24, height: isToday ? 28 : 24, borderRadius: "50%",
                    background: isToday ? "linear-gradient(135deg, #6C63FF, #FF6B8A)" : isPast ? (darkMode ? "#252545" : "#E0E0F0") : theme.accent,
                    boxShadow: isToday ? "0 0 16px rgba(108,99,255,0.5), 0 0 32px rgba(108,99,255,0.2)" : "none",
                    opacity: isPast ? 0.4 : 1,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    transition: "all 0.3s",
                  }}>
                    {isToday ? <div style={{ width: 8, height: 8, borderRadius: "50%", background: "#fff" }} /> : <span style={{ fontSize: 9 }}>{dday.emoji}</span>}
                  </div>
                  {/* Card */}
                  <div onClick={() => onNavigate("detail", dday)}
                    onMouseDown={() => setPressedCard(dday.id)} onMouseUp={() => setPressedCard(null)} onMouseLeave={() => setPressedCard(null)}
                    style={{
                      background: theme.bg, borderRadius: 18, padding: "18px 20px",
                      position: "relative", overflow: "hidden", cursor: "pointer",
                      opacity: isPast ? 0.45 : 1, display: "flex", justifyContent: "space-between", alignItems: "center",
                      boxShadow: darkMode ? "0 4px 16px rgba(0,0,0,0.2)" : "0 3px 14px rgba(0,0,0,0.04)",
                      animation: `fadeSlideIn 0.4s ease-out ${idx * 0.06}s both`,
                      transition: "transform 0.2s cubic-bezier(0.34,1.56,0.64,1)",
                      transform: pressedCard === dday.id ? "scale(0.97)" : "scale(1)",
                    }}>
                    <PatternSVG type={theme.pattern} color={theme.accent} opacity={0.06} />
                    <div style={{ position: "relative", zIndex: 1 }}>
                      <div style={{ display: "flex", alignItems: "center", gap: 7 }}>
                        <span style={{ fontSize: 20 }}>{dday.emoji}</span>
                        <span style={{ fontSize: 14, fontWeight: 700, color: theme.text, fontFamily: "'Outfit',sans-serif" }}>{dday.title}</span>
                      </div>
                      <div style={{ fontSize: 10, color: theme.text, opacity: 0.35, marginTop: 3, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>{dday.date}</div>
                    </div>
                    <div style={{ textAlign: "right", position: "relative", zIndex: 1 }}>
                      <div style={{ fontSize: 24, fontWeight: 800, color: theme.accent, fontFamily: "'Outfit',sans-serif", letterSpacing: -1, lineHeight: 1 }}>
                        {days < 0 ? `+${Math.abs(days)}` : days === 0 ? "🎉" : days}
                      </div>
                      <div style={{ fontSize: 9, color: theme.text, opacity: 0.35, fontFamily: "'Outfit',sans-serif", marginTop: 2, fontWeight: 500 }}>{days < 0 ? "days ago" : days === 0 ? "TODAY" : "days left"}</div>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* FAB */}
      <div onClick={() => onNavigate("create")} style={{
        position: "fixed", bottom: 32, right: 24, width: 60, height: 60, borderRadius: 20,
        background: "linear-gradient(135deg, #6C63FF, #8B5CF6)",
        boxShadow: "0 10px 32px rgba(108,99,255,0.45)",
        display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer",
        color: "#fff", fontSize: 30, fontWeight: 300, zIndex: 100,
        transition: "transform 0.2s cubic-bezier(0.34,1.56,0.64,1), box-shadow 0.2s",
      }} onMouseDown={e => { e.currentTarget.style.transform = "scale(0.9)"; }} onMouseUp={e => { e.currentTarget.style.transform = "scale(1)"; }}>+</div>
    </div>
  );
}

// ============ DETAIL ============
function DetailScreen({ dday, onBack, darkMode }) {
  const [milestoneExpanded, setMilestoneExpanded] = useState(false);
  const days = getDaysFromNow(dday.date);
  const absDays = Math.abs(days);
  const theme = THEMES[dday.theme];
  const isCountUp = days <= 0;

  const bg = darkMode ? "#0A0A16" : "#F6F6FC";
  const textPrimary = darkMode ? "#E8E8FF" : "#1A1A2E";
  const textSecondary = darkMode ? "#6B6B8D" : "#9090A8";

  const milestoneTemplate = [100, 50, 30, 10, 7, 3, 1, 0];
  const targetDate = new Date(dday.date);
  const todayDate = new Date(2026, 2, 1);
  const milestones = milestoneTemplate.map((d) => {
    const msDate = new Date(targetDate); msDate.setDate(msDate.getDate() - d);
    const msDateStr = `${msDate.getFullYear()}-${String(msDate.getMonth() + 1).padStart(2, "0")}-${String(msDate.getDate()).padStart(2, "0")}`;
    const diffFromToday = Math.ceil((msDate - todayDate) / (1000 * 60 * 60 * 24));
    return { days: d, label: d === 0 ? "D-Day" : `D-${d}`, date: msDateStr, reached: diffFromToday <= 0, diffFromToday };
  });

  const preview = milestones.slice(0, 3);
  const displayMilestones = milestoneExpanded ? milestones : preview;
  const weeks = Math.floor(absDays / 7);
  const months = Math.floor(absDays / 30);
  const remainDays = absDays % 7;

  return (
    <div style={{ background: bg, minHeight: "100%" }}>
      {/* Theme Header */}
      <div style={{ background: theme.bg, padding: "24px 24px 48px", position: "relative", overflow: "hidden", borderRadius: "0 0 36px 36px", boxShadow: darkMode ? "0 12px 40px rgba(0,0,0,0.4)" : "0 8px 32px rgba(0,0,0,0.06)" }}>
        <PatternSVG type={theme.pattern} color={theme.accent} opacity={0.12} />
        {/* Top accent line */}
        <div style={{ position: "absolute", top: 0, left: 0, right: 0, height: 3, background: `linear-gradient(90deg, ${theme.accent}, transparent)` }} />
        {/* Nav */}
        <div style={{ display: "flex", justifyContent: "space-between", position: "relative", zIndex: 1 }}>
          <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 12, background: "rgba(255,255,255,0.12)", backdropFilter: "blur(10px)", border: "1px solid rgba(255,255,255,0.15)", cursor: "pointer", fontSize: 18, color: theme.text, display: "flex", alignItems: "center", justifyContent: "center", transition: "transform 0.15s" }} onMouseDown={e => e.currentTarget.style.transform = "scale(0.9)"} onMouseUp={e => e.currentTarget.style.transform = "scale(1)"}>←</button>
          <button style={{ width: 40, height: 40, borderRadius: 12, background: "rgba(255,255,255,0.12)", backdropFilter: "blur(10px)", border: "1px solid rgba(255,255,255,0.15)", cursor: "pointer", fontSize: 16, color: theme.text, display: "flex", alignItems: "center", justifyContent: "center" }}>✏️</button>
        </div>
        <div style={{ textAlign: "center", position: "relative", zIndex: 1, paddingTop: 20 }}>
          <div style={{ fontSize: 52, marginBottom: 10, filter: "drop-shadow(0 4px 8px rgba(0,0,0,0.1))" }}>{dday.emoji}</div>
          <div style={{ fontSize: 20, fontWeight: 700, color: theme.text, fontFamily: "'Outfit',sans-serif", marginBottom: 16, letterSpacing: -0.3 }}>{dday.title}</div>
          <div style={{ fontSize: 80, fontWeight: 800, color: theme.accent, fontFamily: "'Outfit',sans-serif", letterSpacing: -4, lineHeight: 1, filter: "drop-shadow(0 2px 12px rgba(0,0,0,0.15))" }}>
            {isCountUp ? `+${absDays}` : absDays === 0 ? "🎉" : absDays}
          </div>
          <div style={{ fontSize: 14, color: theme.text, opacity: 0.4, marginTop: 10, fontFamily: "'Outfit',sans-serif", fontWeight: 600, letterSpacing: 1 }}>
            {isCountUp ? "days since" : absDays === 0 ? "D-Day!" : "days left"}
          </div>
          {/* Sub counts — Glass */}
          <div style={{ display: "flex", gap: 14, justifyContent: "center", marginTop: 24 }}>
            {[{ value: months, label: "개월" }, { value: weeks, label: "주" }, { value: remainDays, label: "일" }].map((item, i) => (
              <div key={i} style={{ background: "rgba(255,255,255,0.12)", backdropFilter: "blur(12px)", borderRadius: 16, padding: "14px 22px", minWidth: 74, textAlign: "center", border: "1px solid rgba(255,255,255,0.15)" }}>
                <div style={{ fontSize: 24, fontWeight: 800, color: theme.text, fontFamily: "'Outfit',sans-serif" }}>{item.value}</div>
                <div style={{ fontSize: 10, color: theme.text, opacity: 0.4, fontFamily: "'Outfit',sans-serif", marginTop: 2, fontWeight: 500, letterSpacing: 0.5 }}>{item.label}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Milestone */}
      <div style={{ padding: "28px 24px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
          <span style={{ fontSize: 17, fontWeight: 800, color: textPrimary, fontFamily: "'Outfit',sans-serif", letterSpacing: -0.3 }}>마일스톤</span>
          <button style={{ background: "none", border: "none", color: "#6C63FF", fontSize: 13, fontWeight: 600, cursor: "pointer", fontFamily: "'Outfit',sans-serif" }}>+ 커스텀</button>
        </div>
        <div style={{ position: "relative" }}>
          <div style={{ position: "absolute", left: 15, top: 8, bottom: 8, width: 2, background: darkMode ? "linear-gradient(180deg, #6C63FF44, transparent)" : "linear-gradient(180deg, #6C63FF22, transparent)", borderRadius: 1 }} />
          {displayMilestones.map((m, i) => (
            <div key={i} style={{ display: "flex", alignItems: "center", gap: 14, padding: "12px 0", opacity: m.reached ? 0.45 : 1, transition: "opacity 0.3s" }}>
              <div style={{
                width: 32, height: 32, borderRadius: "50%", flexShrink: 0, position: "relative", zIndex: 1,
                background: m.reached ? "linear-gradient(135deg, #43A047, #66BB6A)" : (darkMode ? "rgba(40,40,72,0.5)" : "rgba(240,240,248,0.9)"),
                border: m.reached ? "none" : `2px solid ${darkMode ? "rgba(60,60,100,0.5)" : "rgba(220,220,240,0.9)"}`,
                display: "flex", alignItems: "center", justifyContent: "center", fontSize: 12, color: m.reached ? "#fff" : textSecondary,
                boxShadow: m.reached ? "0 2px 8px rgba(67,160,71,0.3)" : "none",
              }}>{m.reached ? "✓" : "○"}</div>
              <div style={{ width: 48, flexShrink: 0 }}><span style={{ fontSize: 14, fontWeight: 700, color: textPrimary, fontFamily: "'Outfit',sans-serif" }}>{m.label}</span></div>
              <div style={{ flex: 1 }}><span style={{ fontSize: 12, color: textSecondary, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>{m.date}</span></div>
              <span style={{ fontSize: 12, color: m.reached ? "#43A047" : "#6C63FF", fontWeight: 700, fontFamily: "'Outfit',sans-serif", flexShrink: 0 }}>
                {m.reached ? m.diffFromToday === 0 ? "오늘" : `${Math.abs(m.diffFromToday)}일 지남` : `${m.diffFromToday}일 후`}
              </span>
            </div>
          ))}
          {milestones.length > preview.length && (
            <button onClick={() => setMilestoneExpanded(!milestoneExpanded)} style={{
              background: "none", border: "none", color: "#6C63FF", fontSize: 13, fontWeight: 600,
              cursor: "pointer", padding: "14px 0", width: "100%", textAlign: "center", fontFamily: "'Outfit',sans-serif",
              transition: "color 0.2s",
            }}>{milestoneExpanded ? "접기" : `모두 보기 (${milestones.length}개)`}</button>
          )}
        </div>
      </div>

      {/* Share Button */}
      <div style={{ padding: "0 24px 20px" }}>
        <button style={{ width: "100%", padding: "17px", borderRadius: 18, border: "none", background: "linear-gradient(135deg, #6C63FF, #8B5CF6)", color: "#fff", fontSize: 16, fontWeight: 700, cursor: "pointer", fontFamily: "'Outfit',sans-serif", boxShadow: "0 8px 28px rgba(108,99,255,0.3)", transition: "transform 0.15s" }} onMouseDown={e => e.currentTarget.style.transform = "scale(0.97)"} onMouseUp={e => e.currentTarget.style.transform = "scale(1)"}>
          🎴 카드 공유
        </button>
      </div>
      <div style={{ textAlign: "center", padding: "4px 0 36px", fontSize: 11, color: textSecondary, fontFamily: "'Outfit',sans-serif", fontWeight: 500, letterSpacing: 0.3 }}>등록일: 2026-02-15</div>
    </div>
  );
}

// ============ CREATE ============
function CreateScreen({ onBack, darkMode }) {
  const [selectedCategory, setSelectedCategory] = useState("anniversary");
  const [selectedEmoji, setSelectedEmoji] = useState("🎉");
  const [selectedTheme, setSelectedTheme] = useState("cloud");
  const [title, setTitle] = useState("");

  const bg = darkMode ? "#0A0A16" : "#F6F6FC";
  const textPrimary = darkMode ? "#E8E8FF" : "#1A1A2E";
  const textSecondary = darkMode ? "#6B6B8D" : "#9090A8";
  const inputBg = darkMode ? "rgba(26,26,48,0.6)" : "rgba(245,245,252,0.9)";

  const cats = [
    { id: "anniversary", emoji: "🎉", label: "기념일" }, { id: "couple", emoji: "💕", label: "커플" },
    { id: "exam", emoji: "📚", label: "시험" }, { id: "travel", emoji: "✈️", label: "여행" },
    { id: "birthday", emoji: "🎂", label: "생일" }, { id: "baby", emoji: "👶", label: "육아" },
    { id: "custom", emoji: "⚡", label: "커스텀" },
  ];

  const emojiSets = {
    anniversary: ["🎉","🎊","⭐","🏆","🎯","📌","🔔","🚀","🌟","🎁"],
    couple: ["💕","❤️","💑","💍","🌹","💝","😍","💘","🥰","💏"],
    exam: ["📚","✏️","🎓","📝","💪","🧠","📖","🎒","📐","🏫"],
    travel: ["✈️","🌎","🏖️","🗼","⛰️","🚢","🗺️","🧳","🏕️","🎢"],
    birthday: ["🎂","🎈","🎁","🥳","🎊","🕯️","🍰","🎉","🎀","🧁"],
    baby: ["👶","🍼","🎂","👣","🧸","🌟","💖","🍭","👼","🎀"],
    custom: ["⚡","📅","🎯","💡","🔥","🌈","🎪","🏠","💼","🌸"],
  };

  const themeEntries = Object.entries(THEMES);
  const selTheme = THEMES[selectedTheme];

  const SectionLabel = ({ children }) => <label style={{ fontSize: 12, fontWeight: 700, color: textSecondary, marginBottom: 10, display: "block", fontFamily: "'Outfit',sans-serif", letterSpacing: 0.5, textTransform: "uppercase" }}>{children}</label>;

  return (
    <div style={{ background: bg, minHeight: "100%", paddingBottom: 110 }}>
      <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "20px 24px" }}>
        <button onClick={onBack} style={{ background: "none", border: "none", fontSize: 20, cursor: "pointer", color: textPrimary, transition: "transform 0.15s" }} onMouseDown={e => e.currentTarget.style.transform = "scale(0.85)"} onMouseUp={e => e.currentTarget.style.transform = "scale(1)"}>←</button>
        <span style={{ fontSize: 20, fontWeight: 800, color: textPrimary, fontFamily: "'Outfit',sans-serif", letterSpacing: -0.5 }}>D-Day 추가</span>
      </div>
      <div style={{ padding: "0 24px" }}>
        {/* Title */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>제목</SectionLabel>
          <input type="text" placeholder="D-Day 이름 입력" value={title} onChange={e => setTitle(e.target.value)} style={{ width: "100%", padding: "15px 18px", borderRadius: 16, border: `1px solid ${darkMode ? "rgba(255,255,255,0.06)" : "rgba(0,0,0,0.04)"}`, background: inputBg, fontSize: 16, color: textPrimary, fontFamily: "'Outfit',sans-serif", outline: "none", boxSizing: "border-box", transition: "border-color 0.2s" }} onFocus={e => e.target.style.borderColor = "#6C63FF44"} onBlur={e => e.target.style.borderColor = "transparent"} />
        </div>
        {/* Date */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>날짜</SectionLabel>
          <div style={{ padding: "15px 18px", borderRadius: 16, background: inputBg, fontSize: 16, color: textPrimary, fontFamily: "'Outfit',sans-serif", border: `1px solid ${darkMode ? "rgba(255,255,255,0.06)" : "rgba(0,0,0,0.04)"}` }}>2026-03-01</div>
        </div>
        {/* Category */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>카테고리</SectionLabel>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
            {cats.map(c => {
              const active = selectedCategory === c.id;
              return <button key={c.id} onClick={() => { setSelectedCategory(c.id); setSelectedEmoji(c.emoji); }} style={{
                padding: "10px 16px", borderRadius: 14,
                border: active ? "2px solid #6C63FF" : `2px solid ${darkMode ? "rgba(60,60,100,0.4)" : "rgba(230,230,240,0.9)"}`,
                background: active ? (darkMode ? "rgba(108,99,255,0.15)" : "rgba(108,99,255,0.06)") : "transparent",
                fontSize: 13, fontWeight: 600, cursor: "pointer",
                color: active ? "#6C63FF" : textSecondary, fontFamily: "'Outfit',sans-serif",
                transition: "all 0.2s",
              }}>{c.emoji} {c.label}</button>;
            })}
          </div>
        </div>
        {/* Emoji */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>이모지</SectionLabel>
          <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
            <div style={{ width: 56, height: 56, borderRadius: 16, ...glass(darkMode, 10), display: "flex", alignItems: "center", justifyContent: "center", fontSize: 32, flexShrink: 0 }}>{selectedEmoji}</div>
            <div style={{ display: "flex", gap: 6, flexWrap: "wrap", flex: 1 }}>
              {(emojiSets[selectedCategory] || emojiSets.custom).map(e => (
                <button key={e} onClick={() => setSelectedEmoji(e)} style={{
                  width: 38, height: 38, borderRadius: 11,
                  border: selectedEmoji === e ? "2px solid #6C63FF" : "2px solid transparent",
                  background: darkMode ? "rgba(40,40,72,0.4)" : "rgba(245,245,252,0.9)",
                  fontSize: 18, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
                  transition: "all 0.2s cubic-bezier(0.34,1.56,0.64,1)",
                  transform: selectedEmoji === e ? "scale(1.1)" : "scale(1)",
                }}>{e}</button>
              ))}
            </div>
          </div>
        </div>
        {/* Theme */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>테마</SectionLabel>
          <div style={{ display: "flex", gap: 12, overflowX: "auto", paddingBottom: 6 }}>
            {themeEntries.map(([id, t]) => (
              <div key={id} onClick={() => !t.isPro && setSelectedTheme(id)} style={{
                position: "relative", width: 54, height: 54, borderRadius: 16, background: t.bg,
                border: selectedTheme === id ? "3px solid #6C63FF" : "3px solid transparent",
                cursor: t.isPro ? "not-allowed" : "pointer", flexShrink: 0, overflow: "hidden",
                opacity: t.isPro ? 0.6 : 1,
                transition: "all 0.2s cubic-bezier(0.34,1.56,0.64,1)",
                transform: selectedTheme === id ? "scale(1.08)" : "scale(1)",
                boxShadow: selectedTheme === id ? "0 4px 16px rgba(108,99,255,0.3)" : "none",
              }}>
                <PatternSVG type={t.pattern} color={t.accent} opacity={0.2} />
                {t.isPro && <div style={{ position: "absolute", top: -1, right: -1, background: "linear-gradient(135deg, #FFD700, #FFA500)", borderRadius: "0 14px 0 8px", padding: "2px 5px", fontSize: 7, fontWeight: 800, color: "#000" }}>PRO</div>}
              </div>
            ))}
          </div>
        </div>
        {/* Preview */}
        <div style={{ marginBottom: 24 }}>
          <SectionLabel>미리보기</SectionLabel>
          <div style={{ background: selTheme.bg, borderRadius: 22, padding: "22px", position: "relative", overflow: "hidden", boxShadow: darkMode ? "0 8px 28px rgba(0,0,0,0.3)" : "0 4px 20px rgba(0,0,0,0.06)" }}>
            <PatternSVG type={selTheme.pattern} color={selTheme.accent} opacity={0.1} />
            <div style={{ position: "relative", zIndex: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div>
                <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                  <span style={{ fontSize: 24 }}>{selectedEmoji}</span>
                  <span style={{ fontSize: 15, fontWeight: 700, color: selTheme.text, fontFamily: "'Outfit',sans-serif" }}>{title || "D-Day 이름"}</span>
                </div>
                <div style={{ fontSize: 10, color: selTheme.text, opacity: 0.35, marginTop: 5, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>2026-03-01</div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div style={{ fontSize: 32, fontWeight: 800, color: selTheme.accent, fontFamily: "'Outfit',sans-serif", letterSpacing: -1.5, lineHeight: 1 }}>0</div>
                <div style={{ fontSize: 10, color: selTheme.text, opacity: 0.35, fontFamily: "'Outfit',sans-serif", marginTop: 3, fontWeight: 500 }}>D-Day!</div>
              </div>
            </div>
          </div>
        </div>
        {/* Memo */}
        <div style={{ marginBottom: 28 }}>
          <SectionLabel>메모 (선택)</SectionLabel>
          <textarea placeholder="메모를 입력하세요" rows={3} style={{ width: "100%", padding: "15px 18px", borderRadius: 16, border: `1px solid ${darkMode ? "rgba(255,255,255,0.06)" : "rgba(0,0,0,0.04)"}`, background: inputBg, fontSize: 14, color: textPrimary, fontFamily: "'Outfit',sans-serif", outline: "none", resize: "none", boxSizing: "border-box" }} />
        </div>
        {/* Save */}
        <button style={{
          width: "100%", padding: "17px", borderRadius: 18, border: "none",
          background: title.length > 0 ? "linear-gradient(135deg, #6C63FF, #8B5CF6)" : (darkMode ? "rgba(40,40,72,0.5)" : "rgba(230,230,240,0.9)"),
          color: title.length > 0 ? "#fff" : textSecondary,
          fontSize: 16, fontWeight: 700, cursor: title.length > 0 ? "pointer" : "not-allowed",
          fontFamily: "'Outfit',sans-serif",
          boxShadow: title.length > 0 ? "0 8px 28px rgba(108,99,255,0.3)" : "none",
          transition: "all 0.2s",
        }}>저장</button>
      </div>
    </div>
  );
}

// ============ SETTINGS ============
function SettingsScreen({ onBack, darkMode, setDarkMode }) {
  const bg = darkMode ? "#0A0A16" : "#F6F6FC";
  const surface = darkMode ? "rgba(26,26,48,0.6)" : "rgba(255,255,255,0.7)";
  const textPrimary = darkMode ? "#E8E8FF" : "#1A1A2E";
  const textSecondary = darkMode ? "#6B6B8D" : "#9090A8";

  return (
    <div style={{ background: bg, minHeight: "100%" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "20px 24px" }}>
        <button onClick={onBack} style={{ background: "none", border: "none", fontSize: 20, cursor: "pointer", color: textPrimary }}>←</button>
        <span style={{ fontSize: 20, fontWeight: 800, color: textPrimary, fontFamily: "'Outfit',sans-serif", letterSpacing: -0.5 }}>설정</span>
      </div>
      <div style={{ padding: "0 24px" }}>
        {/* PRO Banner — Glass */}
        <div style={{
          ...glass(darkMode, 16),
          background: darkMode ? "rgba(108,99,255,0.1)" : "rgba(108,99,255,0.04)",
          borderRadius: 20, padding: "18px 22px", display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 28,
          border: "1px solid rgba(108,99,255,0.15)",
          boxShadow: "0 4px 20px rgba(108,99,255,0.08)",
        }}>
          <div>
            <div style={{ fontSize: 17, fontWeight: 800, color: textPrimary, fontFamily: "'Outfit',sans-serif" }}>👑 DayCount PRO</div>
            <div style={{ fontSize: 12, color: textSecondary, marginTop: 4, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>모든 테마 & 기능 해금</div>
          </div>
          <div style={{ fontSize: 18, color: "#6C63FF" }}>→</div>
        </div>
        {/* Sections */}
        {[
          { title: "외관", items: [
            { label: "다크 모드", action: <button onClick={() => setDarkMode(!darkMode)} style={{ width: 50, height: 30, borderRadius: 15, background: darkMode ? "linear-gradient(135deg, #6C63FF, #8B5CF6)" : "#E0E0E8", border: "none", cursor: "pointer", position: "relative", transition: "background 0.3s" }}><div style={{ width: 24, height: 24, borderRadius: "50%", background: "#fff", position: "absolute", top: 3, left: darkMode ? 23 : 3, transition: "all 0.3s cubic-bezier(0.34,1.56,0.64,1)", boxShadow: "0 2px 6px rgba(0,0,0,0.15)" }} /></button> },
            { label: "언어", value: "한국어" },
          ]},
          { title: "알림", items: [{ label: "마일스톤 알림", value: "ON" }, { label: "D-Day 알림", value: "ON" }] },
          { title: "정보", items: [{ label: "개인정보처리방침" }, { label: "이용약관" }, { label: "앱 버전", value: "1.0.0" }] },
        ].map((section, si) => (
          <div key={si} style={{ marginBottom: 28 }}>
            <div style={{ fontSize: 11, fontWeight: 700, color: textSecondary, marginBottom: 12, fontFamily: "'Outfit',sans-serif", textTransform: "uppercase", letterSpacing: 1.2 }}>{section.title}</div>
            <div style={{ ...glass(darkMode, 12), borderRadius: 18, overflow: "hidden" }}>
              {section.items.map((item, ii) => (
                <div key={ii} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "15px 18px", borderBottom: ii < section.items.length - 1 ? `1px solid ${darkMode ? "rgba(255,255,255,0.04)" : "rgba(0,0,0,0.03)"}` : "none" }}>
                  <span style={{ fontSize: 15, color: textPrimary, fontFamily: "'Outfit',sans-serif", fontWeight: 500 }}>{item.label}</span>
                  {item.action || <span style={{ fontSize: 13, color: textSecondary, fontFamily: "'Outfit',sans-serif" }}>{item.value || "→"}</span>}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ============ MAIN ============
export default function DayCountPreview() {
  const [screen, setScreen] = useState("home");
  const [selectedDday, setSelectedDday] = useState(null);
  const [darkMode, setDarkMode] = useState(false);

  const navigate = (target, data) => { if (data) setSelectedDday(data); setScreen(target); };

  return (
    <div style={{ maxWidth: 393, margin: "0 auto", height: "100vh", overflow: "auto", position: "relative", background: darkMode ? "#0A0A16" : "#F6F6FC", fontFamily: "'Outfit',-apple-system,sans-serif" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap');
        @keyframes fadeSlideIn { from { opacity:0; transform:translateY(16px) } to { opacity:1; transform:translateY(0) } }
        @keyframes fadeIn { from { opacity:0 } to { opacity:1 } }
        * { box-sizing:border-box; margin:0; padding:0 }
        ::-webkit-scrollbar { display:none }
      `}</style>
      {screen === "home" && <HomeScreen onNavigate={navigate} darkMode={darkMode} />}
      {screen === "detail" && selectedDday && <DetailScreen dday={selectedDday} onBack={() => setScreen("home")} darkMode={darkMode} />}
      {screen === "create" && <CreateScreen onBack={() => setScreen("home")} darkMode={darkMode} />}
      {screen === "settings" && <SettingsScreen onBack={() => setScreen("home")} darkMode={darkMode} setDarkMode={setDarkMode} />}
    </div>
  );
}
