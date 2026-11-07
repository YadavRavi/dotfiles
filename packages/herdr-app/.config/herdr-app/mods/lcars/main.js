// LCARS frame for layouts/lcars.json. One mod, four roles (props().role):
// top (elbow, bars, tabs), side (spaces, agents), bottom (elbow, status), pane (pane header).
// The whole package lives here: layout.json and theme.json are symlinked into layouts/ and themes/.
// Palette: trekcolors lcars colours. Structure: elbow + bars + panels, as on thelcars.com.
import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { spaces, agents, panes, run, openOverlay, props, layout, shared, setAgentOrder, updates, home } from "herdr";

const C = { orange: "#ff9900", tan: "#ffcc99", lilac: "#cc99cc", peri: "#9999cc", blue: "#9999ff", rose: "#cc6666",
  peach: "#ff9966", hop: "#cc6699", gold: "#ffcc66", sky: "#99ccff", red: "#ff3333", black: "#000000" };
const CYCLE = [C.peri, C.lilac, C.tan, C.blue, C.peach, C.hop];
const STATUS = { working: C.gold, blocked: C.red, done: C.sky };
// State: WARP working, RED ALERT blocked, HAILING done (finished, unseen), ORBIT idle, ANOMALY unknown.
const STATE = { working: ["warp", "WARP"], blocked: ["redalert", "RED ALERT"], done: ["hail", "HAILING"], idle: ["orbit", "ORBIT"] };
const ANOMALY = ["anomaly", "ANOMALY"];
const CLASS = { claude: "delta", codex: "tricorder", gemini: "nacelles" }; // any other agent or program: padd
const icon = (name, spin) => { const el = svg(`mods/lcars/icons/${name}.svg`).size(16).flex_none().text_color("#000000"); return spin ? el.spin(1600) : el; };
const stateOf = (status) => STATE[status] ?? ANOMALY;
const BAR = 22, TOP = 72, BOTTOM = 48, ARM = 30;

const up = (s) => String(s ?? "").toUpperCase();
const spaceName = (s) => s?.name === "~" ? "HOME" : up(s?.name ?? "LCARS");
const stop = (_e, cx) => cx.stop_propagation();
const find = (n, id) => n?.id === id ? n : (n?.children ?? []).map((c) => find(c, id)).find(Boolean) ?? null;
const sideWidth = () => { const s = find(layout(), "sidebar"); return s?.hidden ? 84 : s?.size?.px ?? 260; };

// ponytail: 1987 = TNG season 1 = 41xxx, 1000 units a year; the show never defined a real formula.
function stardate() {
  const d = new Date(), y = d.getFullYear();
  const a = new Date(y, 0, 1), b = new Date(y + 1, 0, 1);
  return (41000 + (y - 1987) * 1000 + (d - a) / (b - a) * 1000).toFixed(1);
}
const folder = (cwd) => { const h = home(); return !cwd ? "" : cwd === h ? "~" : cwd.startsWith(h + "/") ? "~" + cwd.slice(h.length) : cwd; };

// A row of blocks: [[width or null for flex, colour], ...]; the last gets the rounded end cap.
const bars = (list) => h_flex().h(BAR).flex_none().gap(4).children(list.map(([w, color, title], i) => {
  if (title !== undefined) return div().flex_none().px(10).max_w(420).truncate().text_size(19).line_height(`${BAR}px`).font_weight(500).text_color(color).child(title);
  const el = div().h_full().bg(color);
  return (w ? el.w(w).flex_none() : el.flex_1()).when(i === list.length - 1, (e) => e.rounded_r(BAR / 2));
}));

const pill = (id, label, color, action, right) => h_flex().id(id).h(26).px(13).flex_none().items_center().rounded(13).bg(color)
  .text_color(C.black).text_size(14).font_weight(500).cursor_pointer().hover((s) => s.bg(C.tan))
  .on_mouse_down("left", stop).on_click(action)
  .when(Boolean(right), (el) => el.on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); right(); }))
  .child(label);

const block = (id, label, color, action) => h_flex().id(id).w_full().h(30).flex_none().px(10).pb(2).items_end().justify_end().bg(color)
  .text_color(C.black).text_size(15).font_weight(500).cursor_pointer().hover((s) => s.bg(C.tan)).on_click(action).child(label);

// [gold bar] TITLE [cap], the way LCARS labels a panel.
const section = (title, count) => h_flex().w_full().h(20).flex_none().gap(6).items_center()
  .child(div().flex_1().h(14).bg(C.gold).rounded_l(7))
  .child(div().flex_none().text_size(16).font_weight(500).text_color(C.gold).child(count === undefined ? title : `${title} ${String(count).padStart(2, "0")}`))
  .child(div().w(10).h(14).flex_none().bg(C.gold));

// A left-capped LCARS row: icons on the cap, right-aligned text, flush to the frame.
const row = (id, { label, sub, color, icons = [], action, right }) => h_flex().id(id).w_full().h(sub ? 42 : 30).flex_none().rounded_l(sub ? 21 : 15).pl(10).pr(8).gap(6).items_center().bg(color)
  .text_color(C.black).cursor_pointer().hover((s) => s.bg(C.tan)).on_click(action)
  .when(Boolean(right), (el) => el.on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); right(); }))
  .children(icons)
  .child(v_flex().flex_1().min_w(0).items_end()
    .child(div().max_w_full().truncate().text_size(15).font_weight(500).child(label))
    .when(Boolean(sub), (el) => el.child(div().max_w_full().truncate().text_size(12).child(sub))));

export default class Lcars extends View {
  init(_props, cx) {
    // Every mod redraw repaints the whole window, so the clock redraws only when the stardate changes.
    if (props()?.role !== "bottom") return;
    cx.timer.every(60000, (cx) => {
      const s = stardate();
      if (s !== this.stardate) { this.stardate = s; cx.notify(); }
    });
  }

  top() {
    const space = spaces().find((s) => s.active), W = sideWidth();
    const panel = find(layout(), "panel"), body = find(layout(), "panel-body");
    const enabled = shared("workspace.panels") ?? ["files", "changes"];
    const panelPill = (id) => {
      const on = panel && !panel.hidden && body?.active === id;
      return pill(`panel-${id}`, up(id), on ? C.orange : C.lilac, () => {
        if (on) run("layout.hide", { id: "panel" });
        else { run("layout.select", { stack: "panel-body", child: id }); run("layout.show", { id: "panel" }); }
      });
    };
    const tab = (c, i) => pill(`tab-${c.id}`, `${c.named ? `${c.index} ${up(c.name)}` : `TAB ${c.index}`}${c.zoomed ? " Z" : ""}`,
      STATUS[c.status] ?? (c.active ? C.orange : CYCLE[i % CYCLE.length]), () => run("tab.select", { id: c.id }),
      () => openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: c.id, space: space.id } } }));
    return h_flex().size_full().bg(C.black)
      .child(div().w(W).h_full().flex_none().bg(C.orange).rounded_tl(48))
      .child(div().w(ARM).h_full().flex_none().relative().bg(C.orange)
        .child(div().absolute().left(0).top(BAR).w(ARM).h(TOP - BAR).bg(C.black).rounded_tl(26)))
      .child(v_flex().flex_1().min_w(0).h_full()
        .child(bars([[null, C.orange], [0, C.orange, spaceName(space)], [90, C.lilac], [28, C.peach], [46, C.blue]]))
        .child(h_flex().flex_1().min_h(0).gap(4).items_center().pr(8)
          .child(h_flex().id("lcars-tabs").flex_1().min_w(0).gap(4).items_center().overflow_x_scroll().children((space?.tabs ?? []).map(tab)))
          .child(pill("tab-new", "+", C.gold, () => openOverlay({ mod: "new-menu", kind: "popup", width: 250, height: 512 })))
          .children(enabled.map(panelPill))));
  }

  side() {
    const list = agents();
    setAgentOrder(list.map((a) => a.address));
    const space = (s, i) => row(`sp-${s.id}`, { label: `${String(s.index).padStart(2, "0")} ${spaceName(s)}`,
      color: s.status === "blocked" ? C.red : s.active ? C.orange : CYCLE[i % CYCLE.length],
      icons: s.status ? [icon(stateOf(s.status)[0], s.status === "working")] : [],
      action: () => run("space.select", { id: s.id }),
      right: () => openOverlay({ mod: "menu", kind: "popup", width: 200, height: 260, props: { tab: "space", target: { id: s.id } } }) });
    const crew = (a) => row(`ag-${a.address}`, { label: [...new Set([spaceName({ name: a.space_name }), up(a.tab_name)])].filter(Boolean).join(" "), sub: `${stateOf(a.status)[1]} · ${up(a.title)}`,
      color: STATUS[a.status] ?? (a.focused ? C.tan : C.peri), icons: [icon(CLASS[a.program?.key] ?? "padd"), icon(stateOf(a.status)[0], a.status === "working")],
      action: () => run("agent.focus", { terminal: a.address }) });
    return v_flex().size_full().bg(C.black).pt(4).pb(4).gap(4)
      .child(v_flex().id("lcars-side").w_full().min_h(0).flex_shrink(1).gap(4).overflow_y_scroll()
        .child(section("SPACES", spaces().length))
        .children(spaces().map(space))
        .when(list.length > 0, (el) => el.child(section("AGENTS", list.length)).children(list.map(crew))))
      .child(div().w_full().flex_1().min_h(10).bg(C.peri))
      .child(block("new-space", "NEW SPACE", C.lilac, () => run("space.new")))
      .child(block("to-main", "STANDARD UI", C.peach, () => run("layout.switch", { name: "main" })))
      .child(block("settings", "SETTINGS", C.rose, () => run("app.settings")));
  }

  bottom() {
    const W = sideWidth(), space = spaces().find((s) => s.active), list = agents();
    const needs = list.filter((a) => a.status === "blocked").length;
    const item = (s, color = C.tan) => div().flex_none().text_size(14).text_color(color).child(s);
    return h_flex().size_full().bg(C.black)
      .child(h_flex().w(W).h_full().flex_none().bg(C.rose).rounded_bl(48).items_end().justify_end().px(8).pb(3)
        .text_size(13).text_color(C.black).font_weight(500).child(`HERDR ${updates()?.app?.version ?? ""}`))
      .child(div().w(ARM).h_full().flex_none().relative().bg(C.rose)
        .child(div().absolute().left(0).top(0).w(ARM).h(BOTTOM - BAR).bg(C.black).rounded_bl(26)))
      .child(v_flex().flex_1().min_w(0).h_full()
        .child(h_flex().flex_1().min_h(0).gap(16).pr(8).items_center()
          .child(item(up(space?.machine ?? "This computer")))
          .when(Boolean(space?.branch), (el) => el.child(item(up(space.branch), C.lilac)))
          .child(item(`${list.length} AGENTS`, C.peri))
          .when(needs > 0, (el) => el.child(item(`${needs} RED ALERT`, C.red)))
          .child(div().flex_1())
          .child(div().id("palette").flex_none().text_size(14).text_color(C.gold).cursor_pointer().on_click(() => run("app.palette")).child("COMMANDS"))
          .child(item(`STARDATE ${this.stardate ??= stardate()}`, C.orange)))
        .child(bars([[120, C.rose], [40, C.lilac], [null, C.peri], [70, C.peach], [46, C.rose]])));
  }

  pane() {
    const p = panes().find((x) => x.pane === props()?.pane);
    if (!p) return div();
    const pane = p.pane, color = STATUS[p.status] ?? (p.focused ? C.orange : C.peri);
    const name = ((p.program?.agent || p.program?.shell) && p.program.name) || p.title || p.program?.name || "shell";
    const btn = (id, label, cmd, args) => div().id(`${id}-${pane}`).h_full().flex_none().px(8).flex().items_center().bg(C.lilac).text_color(C.black)
      .text_size(12).font_weight(500).cursor_pointer().hover((s) => s.bg(C.tan)).on_click((_e, cx) => { cx.stop_propagation(); run(cmd, args); }).child(label);
    return h_flex().id(`lcars-pane-${pane}`).size_full().pb(3).gap(3).items_center().bg(C.black).on_click(() => run("pane.focus", { pane }))
      .child(div().w(12).h_full().flex_none().bg(color).rounded_l(11))
      .child(h_flex().h_full().flex_none().max_w(300).px(8).gap(5).items_center().bg(color).text_color(C.black).text_size(14).font_weight(500)
        .when(Boolean(p.program?.agent), (el) => el.child(icon(CLASS[p.program.key] ?? "padd")))
        .when(Boolean(p.status), (el) => el.child(icon(stateOf(p.status)[0], p.status === "working")))
        .child(div().truncate().child(up(name))))
      .child(div().flex_1().min_w(0).truncate().px(6).text_size(13).text_color(C.tan).child(up(folder(p.cwd))))
      .when(p.status === "blocked", (el) => el.child(div().flex_none().px(6).text_size(13).font_weight(600).text_color(C.red).child("RED ALERT")))
      .child(btn("r", "RIGHT", "pane.split", { direction: "right", pane }))
      .child(btn("d", "DOWN", "pane.split", { direction: "down", pane }))
      .child(btn("z", p.zoomed ? "UNZOOM" : "ZOOM", "pane.zoom", { pane }))
      .child(btn("x", "CLOSE", "pane.close", { pane }))
      .child(div().w(12).h_full().flex_none().bg(color).rounded_r(11));
  }

  render() {
    const role = props()?.role;
    return role === "side" ? this.side() : role === "bottom" ? this.bottom() : role === "pane" ? this.pane() : this.top();
  }
}
