// Screens 1-6: splash, onboarding x3, login, signup
import { sb, icons, logo, ILL, doc } from './helpers.mjs';

const dots = (n) => `<div style="display:flex;gap:6px;justify-content:center">${[1, 2, 3].map(i =>
`<span style="width:${i === n ? 22 : 7}px;height:7px;border-radius:4px;background:${i === n ? 'var(--green)' : 'var(--mint-2)'}"></span>`).join('')}</div>`;

const ob = (n, ill, title, sub, cta, to, last = false) => doc(`ob${n}`, title, `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px;padding:0 32px">
<div style="margin-top:8px">${ill}</div>
<div style="text-align:center"><div style="font-size:24px;font-weight:800;letter-spacing:-.02em">${title}</div>
<p style="margin-top:10px;font-size:14px;line-height:1.55;color:var(--ink-2);max-width:270px">${sub}</p></div></div>
<div style="flex:none;padding:0 28px 34px;display:flex;flex-direction:column;gap:18px;align-items:center">${dots(n)}
<button class="btn" data-to="${to}">${cta}</button>
${last ? '' : `<button style="color:var(--ink-3);font-size:13.5px;font-weight:600" data-to="/login">Skip</button>`}
</div><div class="homebar"></div>`);

const social = `<div style="display:flex;align-items:center;gap:14px;color:var(--ink-3);font-size:12px;font-weight:600"><span style="flex:1;height:1px;background:var(--line)"></span>OR<span style="flex:1;height:1px;background:var(--line)"></span></div>
<div style="display:flex;gap:12px;justify-content:center">
<button class="card" style="width:56px;height:48px;border-radius:14px;display:flex;align-items:center;justify-content:center" data-to="/home"><svg width="22" height="22" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.6 12.3c0-.8-.1-1.5-.2-2.3H12v4.5h5.9a5 5 0 0 1-2.2 3.3v2.8h3.6c2.1-1.9 3.3-4.8 3.3-8.3Z"/><path fill="#34A853" d="M12 23c3 0 5.5-1 7.3-2.7l-3.6-2.8c-1 .7-2.3 1.1-3.7 1.1-2.8 0-5.2-1.9-6.1-4.5H2.2v2.9A11 11 0 0 0 12 23Z"/><path fill="#FBBC05" d="M5.9 14.1a6.6 6.6 0 0 1 0-4.2V7H2.2a11 11 0 0 0 0 10l3.7-2.9Z"/><path fill="#EA4335" d="M12 5.4c1.6 0 3.1.6 4.2 1.7l3.2-3.2A11 11 0 0 0 2.2 7l3.7 2.9c.9-2.6 3.3-4.5 6.1-4.5Z"/></svg></button>
<button class="card" style="width:56px;height:48px;border-radius:14px;display:flex;align-items:center;justify-content:center" data-to="/home"><svg width="20" height="22" viewBox="0 0 20 24" fill="#122019"><path d="M16.7 12.8c0-2.4 2-3.6 2.1-3.6-1.1-1.7-2.9-1.9-3.5-1.9-1.5-.2-2.9.9-3.7.9-.8 0-1.9-.9-3.2-.9-1.6 0-3.2 1-4 2.4-1.7 3-.4 7.4 1.2 9.8.8 1.2 1.8 2.5 3.1 2.4 1.2 0 1.7-.8 3.2-.8s1.9.8 3.2.8c1.3 0 2.2-1.2 3-2.4.9-1.4 1.3-2.7 1.3-2.8 0 0-2.6-1-2.7-3.9ZM14.3 4.9c.7-.8 1.1-1.9 1-3-1 0-2.1.6-2.8 1.4-.6.7-1.2 1.9-1 3 1 .1 2.1-.6 2.8-1.4Z"/></svg></button></div>`;

const head = (t, s) => `<div style="padding:6px 28px 0"><div style="font-size:26px;font-weight:800;letter-spacing:-.02em">${t}</div>
<div style="margin-top:6px;font-size:13.5px;color:var(--ink-2)">${s}</div></div>`;

const fld = (label, inner) => `<div class="fld"><label>${label}</label><div class="box">${inner}</div></div>`;

export default [
{ key: 'splash', label: 'Splash', route: '/splash', body: doc('splash', 'ReCircle - Splash', `${sb()}
<div class="scroll" style="position:relative;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:20px;background:#fff">
<div data-to="/onboarding-1" style="position:absolute;inset:0;cursor:pointer"></div>
<div style="position:relative;z-index:1;display:flex;flex-direction:column;align-items:center;gap:18px">
${logo(96, 28)}
<div style="font-size:34px;font-weight:800;letter-spacing:-.03em">ReCircle</div>
<div style="font-size:14px;color:var(--ink-2);letter-spacing:.02em">Smarter Waste, Greener Tomorrow</div></div>
${ILL.leaves}</div><div class="homebar"></div>`, '<style>.screen{background:#fff}</style>') },
{ key: 'onboarding-1', label: 'Onboarding 1', route: '/onboarding-1', body: ob(1, ILL.bin, 'Scan &amp; Identify', 'Use AI to identify waste types and dispose of them correctly, every time.', 'Next', '/onboarding-2') },
{ key: 'onboarding-2', label: 'Onboarding 2', route: '/onboarding-2', body: ob(2, ILL.globe, 'Earn Eco-Points', 'Recycle, trade or donate and earn rewards for every green action you take.', 'Next', '/onboarding-3') },
{ key: 'onboarding-3', label: 'Onboarding 3', route: '/onboarding-3', body: ob(3, ILL.shop, 'Buy, Sell &amp; Trade', 'Give waste a second life in our marketplace of reusable and recyclable items.', 'Get Started', '/login', true) },
{ key: 'login', label: 'Login', route: '/login', body: doc('login', 'ReCircle - Login', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:22px;padding-top:26px">
${head('Welcome Back', 'Login to continue')}
<div style="display:flex;flex-direction:column;gap:16px;padding:0 28px">
${fld('Email', `<span class="ph">you@example.com</span>`)}
${fld('Password', `<span style="letter-spacing:3px;color:var(--ink)">••••••••</span><span style="flex:1"></span><span style="color:var(--ink-3)">${icons.eye(19)}</span>`)}
<div style="text-align:right;font-size:12.5px;font-weight:700;color:var(--green)">Forgot Password?</div>
<button class="btn" data-to="/home">Login</button>
${social}
<div style="text-align:center;font-size:13px;color:var(--ink-2)">Don't have an account? <b style="color:var(--green)" data-to="/signup">Sign Up</b></div>
</div></div><div class="homebar"></div>`) },
{ key: 'signup', label: 'Sign Up', route: '/signup', body: doc('signup', 'ReCircle - Sign Up', `${sb()}
<div class="scroll" style="display:flex;flex-direction:column;gap:20px;padding-top:14px">
${head('Create Account', 'Join ReCircle and make<br>a greener world')}
<div style="display:flex;flex-direction:column;gap:14px;padding:0 28px">
${fld('Full Name', `<span class="val">Amr Abdelbaki</span>`)}
${fld('Email', `<span class="ph">you@example.com</span>`)}
${fld('Password', `<span style="letter-spacing:3px;color:var(--ink)">••••••••</span><span style="flex:1"></span><span style="color:var(--ink-3)">${icons.eye(19)}</span>`)}
<button class="btn" data-to="/home" style="margin-top:4px">Sign Up</button>
${social}
<div style="text-align:center;font-size:13px;color:var(--ink-2)">Already have an account? <b style="color:var(--green)" data-to="/login">Login</b></div>
</div></div><div class="homebar"></div>`) },
];
