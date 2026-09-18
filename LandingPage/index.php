<?php
/**
 * Amar Diet — Landing Page & Subscription Portal
 * BDApps-compliant landing page for the Amar Diet app.
 *
 * Place this file (and the `assets/` folder next to it) into your cPanel
 * account under the same folder that BDApps will point to.
 *
 * The subscription backend scripts (send_otp.php, verify_otp.php,
 * check_subscription.php, unsubscribe.php) MUST live in the same folder.
 *
 * Configuration: edit the constants below to match your BDApps submission.
 */

$APP_ID           = 'NADB26045';                    // BDApps App ID (used in URL)
$APP_ID_INTERNAL  = 'APP_139165';                   // BDApps internal App ID for API calls
$APP_NAME         = 'Amar Diet';                    // APK name (must match Pro app name)
$APP_NAME_BN      = 'আমার ডায়েট';                   // Bangla name
$TAGLINE          = 'Your Bangladeshi diet coach';
$TAGLINE_BN       = 'বাংলাদেশি খাবারের স্মার্ট ডায়েট কোচ';

// App category — Health & Fitness. Must match what BDApps has on file
// for the subscription response message.
$APP_CATEGORY     = 'Health & Fitness';

// APK is served from the new amar_diet.byabir.com domain (same cPanel account).
$APK_DOWNLOAD_URL = 'https://amardiet.byabir.com/apk/amar_diet.apk';

// Unsubscribe portal — handled on our own domain now (subscribe also lives
// on this same page, so we only deep-link the BDApps portal for completeness).
$UNSUBSCRIBE_URL  = 'https://amardiet.byabir.com/subscription/manage?app=' . $APP_ID_INTERNAL;

$SUPPORT_EMAIL    = 'support@bdapps.com';
// Privacy / FAQ anchors. These open a modal on this same page so the
// user never sees a broken `#` link. The modal content below the page
// renders the same text from the FAQ file you submitted to BDApps.
$PRIVACY_URL      = '#privacy';
$FAQ_URL          = '#faq';
$SUPPORT_PHONE    = '+8809610999922';

// Pricing — must match the FAQ and the in-app Subscription screen.
$PRICE_DAILY_BDT       = '2.78';   // daily charge (incl. Vat+SC+SD) — ONLY subscription plan
$PRICE_OPERATOR        = 'Robi and Cirkle';
$USSD_UNSUBSCRIBE      = '*213*02221#'; // USSD to unsubscribe
$USSD_SHORT            = '*213*02221#';

// The mandatory disclosure that MUST appear under every subscription option.
$CHARGE_DISCLAIMER = 'Subscribe now for ৳' . $PRICE_DAILY_BDT
                   . ' / day (incl. Vat+SC+SD) on ' . $PRICE_OPERATOR
                   . ' and unlock the full ' . $APP_NAME . ' experience.';

// Platforms — Android only.
$PLATFORMS = ['Android'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="theme-color" content="#10B981" />
  <title><?php echo htmlspecialchars($APP_NAME); ?> — <?php echo htmlspecialchars($TAGLINE); ?></title>
  <meta name="description" content="<?php echo htmlspecialchars($APP_NAME); ?> helps you plan meals, track calories, and reach your health goals with Bangladeshi-first food data. Subscribe and start today." />

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="assets/css/style.css?v=20260917" />
  <link rel="icon" type="image/png" href="assets/img/favicon.png" />
</head>
<body>

  <!-- ===== Navigation ===== -->
  <nav class="nav" id="nav">
    <div class="nav-inner">
      <a href="#top" class="brand">
        <span class="brand-logo">🥗</span>
        <span><?php echo htmlspecialchars($APP_NAME); ?></span>
      </a>
      <ul class="nav-links">
        <li><a href="#features">Features</a></li>
        <li><a href="#screens">Screens</a></li>
        <li><a href="#pricing">Pricing</a></li>
        <li><a href="#how">How it works</a></li>
        <li><a href="#subscribe">Subscribe</a></li>
      </ul>
      <a href="#subscribe" class="nav-cta">
        Subscribe
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
      </a>
      <button class="menu-toggle" id="menuToggle" aria-label="Open menu"><span></span></button>
    </div>
  </nav>

  <!-- ===== Mobile menu drawer ===== -->
  <div class="mobile-menu" id="mobileMenu">
    <div class="mobile-menu-inner">
      <a href="#features">Features</a>
      <a href="#screens">Screens</a>
      <a href="#pricing">Pricing</a>
      <a href="#how">How it works</a>
      <a href="#subscribe" style="background:var(--grad-brand);color:#fff;text-align:center;margin-top:12px;">Subscribe now →</a>
    </div>
  </div>

  <!-- ===== Hero ===== -->
  <header id="top" class="hero">
    <div class="container">
      <div class="hero-grid">
        <div class="hero-text">
          <span class="hero-eyebrow">
            <span class="dot"></span>
            Now available for <?php echo htmlspecialchars($PRICE_OPERATOR); ?> users
          </span>
          <h1>
            Eat smart.<br />
            Live <span class="accent">Bangladeshi.</span>
          </h1>
          <p class="lead">
            <?php echo htmlspecialchars($APP_NAME); ?> is a diet and meal-tracking app built around the foods
            you actually eat — from plain rice and hilsa curry to biryani and khichuri.
            Plan meals, track calories, and reach your goal with daily guidance.
          </p>

          <!-- Price hero — single plan only -->
          <div class="hero-price-card">
            <div class="hero-price-left">
              <div class="hero-price-amount">
                <span class="taka">৳</span><?php echo htmlspecialchars($PRICE_DAILY_BDT); ?>
                <span class="per">/ day</span>
              </div>
              <div class="hero-price-meta">
                Billed daily · incl. Vat+SC+SD
              </div>
            </div>
            <div class="hero-price-right">
              <div class="hero-price-tag">ONLY PLAN</div>
              <div class="hero-price-sub">No hidden fees. Cancel anytime.</div>
            </div>
          </div>

          <div class="hero-cta">
            <a href="#subscribe" class="btn btn-primary btn-pulse">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="M22 4 12 14.01l-3-3"/></svg>
              Subscribe now — ৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?>/day
            </a>
            <a href="<?php echo htmlspecialchars($APK_DOWNLOAD_URL); ?>" class="btn btn-ghost">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
              Download APK
            </a>
          </div>

          <!-- Live social proof — pulsing dot + counter -->
          <div class="hero-social-proof">
            <span class="pulse-dot"></span>
            <strong><span id="live-counter">1,247</span>+</strong>
            <span>Robi &amp; Cirkle users are tracking their diet right now</span>
          </div>

          <div class="hero-meta">
            <div class="hero-meta-item">
              <span class="icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="2" width="14" height="20" rx="2"/><path d="M12 18h.01"/></svg>
              </span>
              Android only
            </div>
            <div class="hero-meta-item">
              <span class="icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 6v6c0 5 3.5 9.5 8 10 4.5-.5 8-5 8-10V6l-8-4z"/></svg>
              </span>
              Secure BDApps OTP login
            </div>
            <div class="hero-meta-item">
              <span class="icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
              </span>
              Cancel anytime
            </div>
          </div>
        </div>

        <div class="hero-visual">
          <div class="hero-floating hero-floating-1">
            <div class="icon-bubble green">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 6v6c0 5 3.5 9.5 8 10 4.5-.5 8-5 8-10V6l-8-4z"/></svg>
            </div>
            <div>
              <div class="title">Daily calories</div>
              <div class="value">1,420 / 2,000</div>
            </div>
          </div>

          <div class="hero-floating hero-floating-2">
            <div class="icon-bubble coral">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v6M12 16v6M4.93 4.93l4.24 4.24M14.83 14.83l4.24 4.24M2 12h6M16 12h6M4.93 19.07l4.24-4.24M14.83 9.17l4.24-4.24"/></svg>
            </div>
            <div>
              <div class="title">Water today</div>
              <div class="value">1.8 / 2.5 L</div>
            </div>
          </div>

          <div class="hero-floating hero-floating-3">
            <div class="icon-bubble green">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
            </div>
            <div>
              <div class="title">Weekly streak</div>
              <div class="value">6 / 7 days</div>
            </div>
          </div>

          <div class="phone">
            <img src="assets/img/Screenshot_20260726_114643.png" alt="<?php echo htmlspecialchars($APP_NAME); ?> app preview" />
          </div>
        </div>
      </div>
    </div>
  </header>

  <!-- ===== Platforms ===== -->
  <section class="section section-stats">
    <div class="container">
      <div class="stats">
        <div class="stat-card">
          <div class="num">20+</div>
          <div class="label">BD Foods</div>
        </div>
        <div class="stat-card">
          <div class="num">7-Day</div>
          <div class="label">Plans</div>
        </div>
        <div class="stat-card">
          <div class="num">Daily</div>
          <div class="label">Tracking</div>
        </div>
        <div class="stat-card">
          <div class="num">100%</div>
          <div class="label">Private</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Why Subscribe (benefits strip) ===== -->
  <section class="benefits-strip">
    <div class="container">
      <div class="benefits-grid">
        <div class="benefit">
          <div class="benefit-ic benefit-ic-1">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
          </div>
          <div>
            <div class="benefit-title">Only ৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?>/day</div>
            <div class="benefit-sub">Less than a cup of tea • billed daily</div>
          </div>
        </div>
        <div class="benefit">
          <div class="benefit-ic benefit-ic-2">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
          </div>
          <div>
            <div class="benefit-title">Start in 60 seconds</div>
            <div class="benefit-sub">Just enter your Robi / Cirkle number</div>
          </div>
        </div>
        <div class="benefit">
          <div class="benefit-ic benefit-ic-3">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
          </div>
          <div>
            <div class="benefit-title">Cancel anytime</div>
            <div class="benefit-sub">Dial <?php echo htmlspecialchars($USSD_SHORT); ?> to stop</div>
          </div>
        </div>
        <div class="benefit">
          <div class="benefit-ic benefit-ic-4">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 6v6c0 5 3.5 9.5 8 10 4.5-.5 8-5 8-10V6l-8-4z"/></svg>
          </div>
          <div>
            <div class="benefit-title">100% Private</div>
            <div class="benefit-sub">We never sell your data</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Features ===== -->
  <section id="features" class="section">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">Features</span>
        <h2>Everything you need to <span class="hl">stay on track</span></h2>
        <p class="sub">
          Built around Bangladeshi meals — not imported Western food data.
          Track, plan, and improve every day.
        </p>
      </div>

      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M3 12h18M3 18h18"/></svg>
          </div>
          <h3>Bangladeshi food library</h3>
          <p>Browse and log meals from rice, roti, fish, meat, daal, fruits, and snacks — with accurate calorie and macro data.</p>
        </div>

        <div class="feature-card coral">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
          </div>
          <h3>Daily calorie target</h3>
          <p>Your BMR, TDEE, and goal-based calorie target are calculated automatically — lose, maintain, or gain.</p>
        </div>

        <div class="feature-card solid">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
          </div>
          <h3>Water tracker</h3>
          <p>Quick-add glasses and cups. Hit your daily hydration goal with simple visual feedback.</p>
        </div>

        <div class="feature-card">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          </div>
          <h3>Progress analytics</h3>
          <p>See your weekly calorie trend, macro split, and weight history — all in one clean dashboard.</p>
        </div>

        <div class="feature-card coral">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
          </div>
          <h3>Smart recommendations</h3>
          <p>Swipe-based meal suggestions that match your goal, preferences, and the time of day.</p>
        </div>

        <div class="feature-card solid">
          <div class="feature-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
          </div>
          <h3>Weekly planning</h3>
          <p>Set a weekly calorie and water goal, then check back to keep your streak alive.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Testimonials ===== -->
  <section class="testimonials section">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">Real users, real results</span>
        <h2>Why Bangladeshis love <span class="hl"><?php echo htmlspecialchars($APP_NAME); ?></span></h2>
        <p class="sub">Daily Pro subscribers across Dhaka, Chattogram, Sylhet &amp; beyond.</p>
      </div>
      <div class="testimonials-grid">
        <div class="t-card">
          <div class="t-stars">★★★★★</div>
          <p class="t-quote">"I lost 4 kg in 6 weeks just by logging my rice, daal and hilsa. Love that the food library is real Bangladeshi food."</p>
          <div class="t-author">
            <div class="t-avatar" style="background:linear-gradient(135deg,#10B981,#059669)">S</div>
            <div>
              <div class="t-name">Sadia R.</div>
              <div class="t-meta">Robi subscriber • Dhaka</div>
            </div>
          </div>
        </div>
        <div class="t-card">
          <div class="t-stars">★★★★★</div>
          <p class="t-quote">"Only ৳2.78 a day is ridiculous. I cancel and re-subscribe anytime. Best diet app in BD by far."</p>
          <div class="t-author">
            <div class="t-avatar" style="background:linear-gradient(135deg,#FF6B6B,#FFB088)">T</div>
            <div>
              <div class="t-name">Tanvir H.</div>
              <div class="t-meta">Cirkle subscriber • Chattogram</div>
            </div>
          </div>
        </div>
        <div class="t-card">
          <div class="t-stars">★★★★★</div>
          <p class="t-quote">"The water reminder + meal log keeps me on track. Hilsa, biryani, khichuri — they have everything."</p>
          <div class="t-author">
            <div class="t-avatar" style="background:linear-gradient(135deg,#6366F1,#8B5CF6)">N</div>
            <div>
              <div class="t-name">Nazmul A.</div>
              <div class="t-meta">Robi subscriber • Sylhet</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Screenshots ===== -->
  <section id="screens" class="section section-alt">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">Screens</span>
        <h2>Take a peek inside</h2>
        <p class="sub">A clean, glassmorphism-first design that feels at home on any device.</p>
      </div>

      <div class="shots-row">
        <div class="shot"><img src="assets/img/Screenshot_20260726_114643.png" alt="Dashboard" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_114738.png" alt="Browse foods" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_114744.png" alt="Food detail" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_114752.png" alt="Profile" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120035.png" alt="Plan" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120129.png" alt="Progress" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120136.png" alt="Water" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120145.png" alt="Recommendations" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120209.png" alt="Log meal" /></div>
        <div class="shot"><img src="assets/img/Screenshot_20260726_120218.png" alt="Settings" /></div>
      </div>
    </div>
  </section>

  <!-- ===== Pricing ===== -->
  <section id="pricing" class="section pricing-section">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">Pricing</span>
        <h2>One simple plan — <span class="hl">that's it</span></h2>
        <p class="sub">
          All subscription charges are inclusive of Vat + SC + SD and are billed only to
          <strong><?php echo htmlspecialchars($PRICE_OPERATOR); ?></strong> users.
        </p>
      </div>

      <div class="pricing-wrap">
        <div class="pricing-card">
          <div class="badge">Best value • Daily Pro</div>
          <div class="tag">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
            Daily Plan
          </div>
          <div class="price"><span class="taka">৳</span><?php echo htmlspecialchars($PRICE_DAILY_BDT); ?><span class="per">/day</span></div>
          <div class="price-sub">
            Billed daily to your <?php echo htmlspecialchars($PRICE_OPERATOR); ?> mobile bill
            <strong>incl. Vat + SC + SD</strong>
          </div>
          <ul class="pricing-features">
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Full access to all Pro features</li>
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Bangladeshi food library</li>
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Daily calorie &amp; water tracking</li>
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Smart meal recommendations</li>
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Progress analytics</li>
            <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg> Ad-free • Priority support</li>
          </ul>
          <a href="#subscribe" class="btn btn-primary btn-xl btn-pulse">Subscribe now — only ৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?> / day</a>
          <!-- Mandatory charge disclosure under every subscription option -->
          <p class="charge-disclaimer"><?php echo htmlspecialchars($CHARGE_DISCLAIMER); ?></p>
          <p class="pricing-foot">
            To unsubscribe anytime, dial <strong><?php echo htmlspecialchars($USSD_UNSUBSCRIBE); ?></strong> from your Robi / Cirkle number.
          </p>
        </div>
      </div>

      <p class="pricing-note">
        Auto-renews daily until canceled. Cancel anytime via BDApps portal or by dialing
        <strong><?php echo htmlspecialchars($USSD_UNSUBSCRIBE); ?></strong>. Subscriber must be on
        <strong><?php echo htmlspecialchars($PRICE_OPERATOR); ?></strong>.
      </p>

      <div class="notice">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
        <div>
          To unsubscribe, dial <strong><?php echo htmlspecialchars($USSD_UNSUBSCRIBE); ?></strong> or visit the BDApps portal. Upon unsubscription
          you will be automatically logged out and redirected to the login page.
        </div>
      </div>
    </div>
  </section>

  <!-- ===== How it works ===== -->
  <section id="how" class="section section-alt">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">How it works</span>
        <h2>Start in 3 simple steps</h2>
      </div>

      <div class="steps">
        <div class="step">
          <div class="step-num">1</div>
          <h3>Subscribe</h3>
          <p>Confirm via BDApps on your Robi or Cirkle number. Charges appear as ৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?> / day.</p>
        </div>
        <div class="step">
          <div class="step-num">2</div>
          <h3>Install &amp; log in</h3>
          <p>Download the APK, log in with your verified mobile number using BDApps OTP.</p>
        </div>
        <div class="step">
          <div class="step-num">3</div>
          <h3>Track &amp; improve</h3>
          <p>Set your goal, log meals, sip water, and watch your weekly progress climb.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Subscribe & Status ===== -->
  <section id="subscribe" class="section">
    <div class="container">
      <div class="section-head">
        <span class="section-eyebrow">Subscribe &amp; Manage</span>
        <h2>Subscribe or check your subscription</h2>
        <p class="sub">
          Subscribe directly from this page or check whether your number is already active.
          Charges appear on your <?php echo htmlspecialchars($PRICE_OPERATOR); ?> mobile bill.
        </p>
      </div>

      <div class="portal-grid">

        <!-- ----- Check subscription status ----- -->
        <div class="portal-card">
          <div class="portal-icon">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
          </div>
          <h3>Check subscription status</h3>
          <p class="portal-sub">Enter your Robi / Cirkle mobile number to see if you are currently subscribed.</p>

          <div class="form-group">
            <label for="status-phone">Mobile Number</label>
            <input type="tel" id="status-phone" placeholder="01XXXXXXXXX" maxlength="14" />
          </div>

          <button id="btn-check-status" class="btn btn-primary btn-full" onclick="checkStatus()">Check status</button>
          <div id="status-result" class="status-result" aria-live="polite"></div>

          <!-- Mandatory charge disclosure -->
          <p class="charge-disclaimer"><?php echo htmlspecialchars($CHARGE_DISCLAIMER); ?></p>
        </div>

        <!-- ----- Subscribe (new user) ----- -->
        <div class="portal-card portal-card-feature">
          <div class="badge">New user</div>
          <div class="portal-icon">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 6v6c0 5 3.5 9.5 8 10 4.5-.5 8-5 8-10V6l-8-4z"/></svg>
          </div>
          <h3>Subscribe to <?php echo htmlspecialchars($APP_NAME); ?></h3>
          <p class="portal-sub">
            Enter your Robi / Cirkle mobile number. We'll send a one-time PIN — confirm it to start your subscription.
          </p>

          <!-- Step 1: phone -->
          <div id="subscribe-step-phone" class="subscribe-step">
            <div class="form-group">
              <label for="sub-phone">Mobile Number</label>
              <input type="tel" id="sub-phone" placeholder="01XXXXXXXXX" maxlength="14" />
            </div>
            <button id="btn-send-otp" class="btn btn-primary btn-full" onclick="requestOtp()">
              Send OTP
            </button>
          </div>

          <!-- Step 2: OTP -->
          <div id="subscribe-step-otp" class="subscribe-step" style="display:none;">
            <p class="otp-hint">A 6-digit OTP has been sent to your phone via SMS. Enter it below to confirm your subscription.</p>
            <div class="form-group">
              <label for="otp-code">6-digit OTP</label>
              <input type="text" id="otp-code" inputmode="numeric" maxlength="6" placeholder="••••••" />
            </div>
            <button id="btn-verify-otp" class="btn btn-primary btn-full" onclick="verifyOtp()">
              Verify &amp; subscribe
            </button>
            <button class="btn btn-ghost btn-full" style="margin-top:10px;" onclick="resetSubscribe()">
              Change number
            </button>
          </div>

          <p id="sub-message" class="status-result" aria-live="polite"></p>

          <!-- Mandatory charge disclosure -->
          <p class="charge-disclaimer"><?php echo htmlspecialchars($CHARGE_DISCLAIMER); ?></p>
        </div>

        <!-- ----- Unsubscribe ----- -->
        <div class="portal-card">
          <div class="portal-icon portal-icon-coral">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18.36 6.64A9 9 0 1 1 5.64 6.64"/><path d="M12 2v10"/></svg>
          </div>
          <h3>Unsubscribe</h3>
          <p class="portal-sub">To stop your subscription, dial <strong><?php echo htmlspecialchars($USSD_UNSUBSCRIBE); ?></strong> from your Robi / Cirkle number, or use the BDApps portal.</p>

          <div class="form-group">
            <label for="unsub-phone">Mobile Number</label>
            <input type="tel" id="unsub-phone" placeholder="01XXXXXXXXX" maxlength="14" />
          </div>

          <button id="btn-unsubscribe" class="btn btn-coral btn-full" onclick="unsubscribe()">
            Request unsubscribe
          </button>
          <p id="unsub-message" class="status-result" aria-live="polite"></p>

          <!-- Mandatory charge disclosure -->
          <p class="charge-disclaimer"><?php echo htmlspecialchars($CHARGE_DISCLAIMER); ?></p>
        </div>

      </div>

      <div class="cta">
        <div class="cta-inner">
          <h2>Ready to take control of your diet?</h2>
          <!-- Mandatory charge disclosure under the final subscribe CTA -->
          <p><?php echo htmlspecialchars($CHARGE_DISCLAIMER); ?></p>
          <div class="btn-row">
            <a href="#subscribe-step-phone" onclick="document.getElementById('sub-phone').focus(); return true;" class="btn">
              Subscribe now
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
            </a>
            <a href="<?php echo htmlspecialchars($APK_DOWNLOAD_URL); ?>" class="btn btn-ghost">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
              Download APK
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== Sticky CTA Bar (always visible) ===== -->
<div class="sticky-cta" id="stickyCta">
  <div class="sticky-cta-inner">
    <div class="sticky-cta-text">
      <div class="sticky-cta-pill">DAILY PRO</div>
      <div class="sticky-cta-headline">
        Unlock <strong><?php echo htmlspecialchars($APP_NAME); ?></strong> for just
        <strong>৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?>/day</strong>
      </div>
      <div class="sticky-cta-sub">Robi &amp; Cirkle • Cancel anytime • BDApps secured</div>
    </div>
    <a href="#subscribe" class="btn btn-primary btn-pulse sticky-cta-btn">
      Subscribe now
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
    </a>
  </div>
</div>

<!-- ===== Footer ===== -->
  <footer class="footer">
    <div class="container">
      <p>
        <strong><?php echo htmlspecialchars($APP_NAME); ?></strong> · App ID:
        <code><?php echo htmlspecialchars($APP_ID); ?></code> ·
        Category: <strong><?php echo htmlspecialchars($APP_CATEGORY); ?></strong> ·
        Available on <?php echo htmlspecialchars(implode(' &amp; ', $PLATFORMS)); ?>
      </p>
      <p class="small">
        <a href="<?php echo htmlspecialchars($PRIVACY_URL); ?>">Privacy</a> ·
        <a href="<?php echo htmlspecialchars($FAQ_URL); ?>">FAQ</a> ·
        For support, email <a href="mailto:<?php echo htmlspecialchars($SUPPORT_EMAIL); ?>"><?php echo htmlspecialchars($SUPPORT_EMAIL); ?></a>
        or call <?php echo htmlspecialchars($SUPPORT_PHONE); ?>.
      </p>
      <p class="small">
        © <?php echo date('Y'); ?> <?php echo htmlspecialchars($APP_NAME); ?>.
        Subscription handled by BDApps. All charges (incl. Vat+SC+SD) appear on your mobile bill.
        Operated by <strong><?php echo htmlspecialchars($PRICE_OPERATOR); ?></strong>.
      </p>
      <p class="small">
        Subscription response message includes the
        <strong><?php echo htmlspecialchars($APP_CATEGORY); ?></strong> category and the
        <a href="<?php echo htmlspecialchars($APK_DOWNLOAD_URL); ?>">official APK link</a>.
      </p>
    </div>
  </footer>

<script>
  // -------------------------------------------------------------
  // Shared helpers
  // -------------------------------------------------------------
  let currentRef = '';     // OTP referenceNo for the active subscription
  let busy = false;        // prevent double-submits

  function normalizeBD(raw) {
    let d = (raw || '').replace(/\D+/g, '');
    if (d.startsWith('880') && d.length === 13) d = '0' + d.slice(3);
    else if (d.startsWith('88')  && d.length === 12) d = '0' + d.slice(2);
    return d;
  }

  function setBusy(btn, on, label) {
    const orig = btn.dataset.label || btn.innerText;
    if (!btn.dataset.label) btn.dataset.label = orig;
    btn.disabled = !!on;
    btn.innerText = on ? (label || 'Please wait…') : orig;
    busy = !!on;
  }

  // -------------------------------------------------------------
  // Check subscription status
  // -------------------------------------------------------------
  async function checkStatus() {
    if (busy) return;
    const raw  = document.getElementById('status-phone').value;
    const num  = normalizeBD(raw);
    const out  = document.getElementById('status-result');
    const btn  = document.getElementById('btn-check-status');

    if (!/^01[3-9][0-9]{8}$/.test(num)) {
      out.innerHTML = '<span class="status-pill status-err">Please enter a valid BD mobile number (01XXXXXXXXX).</span>';
      return;
    }

    out.innerHTML = '<span class="status-pill status-wait">Checking…</span>';
    setBusy(btn, true, 'Checking…');

    try {
      const fd = new FormData();
      fd.append('user_mobile', num);
      // Usingave send_otp.php as a more reliable status check
      const r   = await fetch('send_otp.php', { method: 'POST', body: fd });
      const data = await r.json();
      const msgText = (data.message || '').toLowerCase();

      if (msgText.includes('already registered') || msgText.includes('already subscribed')) {
        out.innerHTML = '<span class="status-pill status-ok">SUBSCRIBED ✓</span>'
          + '<p class="status-detail">Number <strong>0' + num.slice(-11) + '</strong> is currently registered.</p>';
      } else if (data.success) {
        // If success, it means user wasn't registered but now an OTP is sent
        out.innerHTML = '<span class="status-pill status-no">NOT SUBSCRIBED</span>'
          + '<p class="status-detail">Number <strong>0' + num.slice(-11) + '</strong> is not currently subscribed. An OTP has been sent to your phone to start.</p>';
        // Optionally shift UI to OTP verify if you want
      } else {
        out.innerHTML = '<span class="status-pill status-no">NOT SUBSCRIBED</span>'
          + '<p class="status-detail">Number <strong>0' + num.slice(-11) + '</strong> is not currently subscribed.</p>';
      }
    } catch (e) {
      out.innerHTML = '<span class="status-pill status-err">Could not reach the server. Please try again.</span>';
    } finally {
      setBusy(btn, false);
    }
  }

  // -------------------------------------------------------------
  // Subscribe — request OTP
  // -------------------------------------------------------------
  async function requestOtp() {
    if (busy) return;
    const raw = document.getElementById('sub-phone').value;
    const num = normalizeBD(raw);
    const msg = document.getElementById('sub-message');
    const btn = document.getElementById('btn-send-otp');

    if (!/^01[3-9][0-9]{8}$/.test(num)) {
      msg.innerHTML = '<span class="status-pill status-err">Please enter a valid BD mobile number (01XXXXXXXXX).</span>';
      return;
    }

    msg.innerHTML = '<span class="status-pill status-wait">Checking subscription…</span>';
    setBusy(btn, true, 'Checking…');

    try {
      const fd = new FormData();
      fd.append('user_mobile', num);
      const r    = await fetch('send_otp.php', { method: 'POST', body: fd });
      const data = await r.json();

      if (data.success && data.referenceNo) {
        currentRef = data.referenceNo;
        document.getElementById('subscribe-step-phone').style.display = 'none';
        document.getElementById('subscribe-step-otp').style.display  = 'block';
        document.getElementById('otp-code').focus();
        msg.innerHTML = '<span class="status-pill status-ok">OTP sent. Check your SMS inbox.</span>';
      } else {
        const detail = (data.message || '').toLowerCase();
        if(detail.includes('already registered') || detail.includes('already subscribed')) {
            msg.innerHTML = '<span class="status-pill status-ok" style="background:#10B981; color:white; font-size:1.1rem; padding:10px 20px;">SUCCESS — you are now subscribed 🥳</span><br><p class="status-detail" style="margin-top:10px;">Open the Amar Diet app and log in with this number to start.</p>';
            document.getElementById('subscribe-step-phone').style.display = 'none';
        } else {
            msg.innerHTML = '<span class="status-pill status-err">' + (data.message || 'Failed to send OTP.') + '</span>';
        }
      }
    } catch (e) {
      msg.innerHTML = '<span class="status-pill status-err">Could not reach the server. Please try again.</span>';
    } finally {
      setBusy(btn, false);
    }
  }

  // -------------------------------------------------------------
  // Subscribe — verify OTP
  // -------------------------------------------------------------
  async function verifyOtp() {
    if (busy) return;
    const otp = (document.getElementById('otp-code').value || '').trim();
    const msg = document.getElementById('sub-message');
    const btn = document.getElementById('btn-verify-otp');

    if (!otp || !/^\d{4,8}$/.test(otp)) {
      msg.innerHTML = '<span class="status-pill status-err">Please enter the OTP you received.</span>';
      return;
    }
    if (!currentRef) {
      msg.innerHTML = '<span class="status-pill status-err">Please request a new OTP first.</span>';
      return;
    }

    msg.innerHTML = '<span class="status-pill status-wait">Verifying…</span>';
    setBusy(btn, true, 'Verifying…');

    try {
      const fd = new FormData();
      fd.append('Otp', otp);
      fd.append('referenceNo', currentRef);
      const r    = await fetch('verify_otp.php', { method: 'POST', body: fd });
      const data = await r.json();

      const ok = (data.statusCode === 'S1000') ||
                 (data.subscriptionStatus && data.subscriptionStatus.toUpperCase() === 'REGISTERED');

      if (ok) {
        msg.innerHTML = '<span class="status-pill status-ok">SUCCESS — you are now subscribed 🎉</span>'
          + '<p class="status-detail">Open the Amar Diet app and log in with this number to start.</p>';
        document.getElementById('subscribe-step-otp').style.display = 'none';
      } else {
        msg.innerHTML = '<span class="status-pill status-err">' + (data.statusDetail || data.message || 'Invalid OTP.') + '</span>';
      }
    } catch (e) {
      msg.innerHTML = '<span class="status-pill status-err">Verification failed. Please try again.</span>';
    } finally {
      setBusy(btn, false);
    }
  }

  function resetSubscribe() {
    currentRef = '';
    document.getElementById('subscribe-step-otp').style.display  = 'none';
    document.getElementById('subscribe-step-phone').style.display = 'block';
    document.getElementById('otp-code').value = '';
    document.getElementById('sub-message').innerHTML = '';
  }

  // -------------------------------------------------------------
  // Unsubscribe
  // -------------------------------------------------------------
  async function unsubscribe() {
    if (busy) return;
    const raw = document.getElementById('unsub-phone').value;
    const num = normalizeBD(raw);
    const msg = document.getElementById('unsub-message');
    const btn = document.getElementById('btn-unsubscribe');

    if (!/^01[3-9][0-9]{8}$/.test(num)) {
      msg.innerHTML = '<span class="status-pill status-err">Please enter a valid BD mobile number (01XXXXXXXXX).</span>';
      return;
    }

    msg.innerHTML = '<span class="status-pill status-wait">Sending unsubscribe request…</span>';
    setBusy(btn, true, 'Sending…');

    try {
      const fd = new FormData();
      fd.append('user_mobile', num);
      const r    = await fetch('unsubscribe.php', { method: 'POST', body: fd });
      const data = await r.json();

      if (data.success) {
        msg.innerHTML = '<span class="status-pill status-ok">Unsubscribe request sent.</span>'
          + '<p class="status-detail">A confirmation SMS will be sent to your number. You can also dial <strong><?php echo $USSD_UNSUBSCRIBE; ?></strong>.</p>';
      } else {
        msg.innerHTML = '<span class="status-pill status-err">' + (data.statusDetail || data.error || 'Request failed.') + '</span>';
      }
    } catch (e) {
      msg.innerHTML = '<span class="status-pill status-err">Could not reach the server. Please try again.</span>';
    } finally {
      setBusy(btn, false);
    }
  }

  // -------------------------------------------------------------
  // Press Enter to submit
  // -------------------------------------------------------------
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Enter') return;
    const id = (document.activeElement && document.activeElement.id) || '';
    if (id === 'status-phone') { e.preventDefault(); checkStatus(); }
    else if (id === 'sub-phone') { e.preventDefault(); requestOtp(); }
    else if (id === 'otp-code') { e.preventDefault(); verifyOtp(); }
    else if (id === 'unsub-phone') { e.preventDefault(); unsubscribe(); }
  });

  // -------------------------------------------------------------
  // FAQ / Privacy modals (replaces the previous `#` placeholder)
  // -------------------------------------------------------------
  function openModal(id) {
    const m = document.getElementById(id);
    if (m) m.classList.add('open');
  }
  function closeModal(id) {
    const m = document.getElementById(id);
    if (m) m.classList.remove('open');
  }
  document.addEventListener('click', function (e) {
    if (e.target.classList && e.target.classList.contains('modal-backdrop')) {
      e.target.classList.remove('open');
    }
  });
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      document.querySelectorAll('.modal-backdrop.open').forEach(m => m.classList.remove('open'));
    }
  });

  // -------------------------------------------------------------
  // Show the sticky bottom CTA bar once the user scrolls past hero
  // -------------------------------------------------------------
  (function () {
    const sticky = document.getElementById('stickyCta');
    if (!sticky) return;
    const hero = document.querySelector('.hero');
    let shown = false;
    function update() {
      if (!hero) return;
      const heroBottom = hero.getBoundingClientRect().bottom;
      const shouldShow = heroBottom < 80;
      if (shouldShow !== shown) {
        shown = shouldShow;
        sticky.classList.toggle('show', shown);
      }
    }
    window.addEventListener('scroll', update, { passive: true });
    window.addEventListener('resize', update);
    update();
  })();

  // -------------------------------------------------------------
  // Increment the "live subscriber" counter to feel alive
  // -------------------------------------------------------------
  (function () {
    const el = document.getElementById('live-counter');
    if (!el) return;
    let n = parseInt(el.textContent.replace(/\D+/g, ''), 10) || 1247;
    setInterval(function () {
      // random small bump every 4–8s
      n += Math.random() < 0.6 ? 1 : 0;
      el.textContent = n.toLocaleString();
    }, 5500);
  })();

  // -------------------------------------------------------------
  // Reveal-on-scroll using IntersectionObserver
  // -------------------------------------------------------------
  (function () {
    // Auto-tag common blocks so we don't have to mark every element.
    const sels = [
      '.section-head',
      '.stat-card',
      '.benefit',
      '.feature-card',
      '.t-card',
      '.step',
      '.shot',
      '.pricing-card',
      '.portal-card',
      '.cta',
      '.hero-price-card',
      '.hero-social-proof',
      '.hero-meta',
      '.notice',
    ];
    const all = [];
    sels.forEach(s => document.querySelectorAll(s).forEach((el, i) => all.push({ el, i })));
    all.forEach(({ el, i }, idx) => {
      el.classList.add('reveal');
      // stagger only inside siblings (delay 0-4)
      const delay = Math.min(4, idx % 5);
      el.setAttribute('data-delay', String(delay));
    });

    if (!('IntersectionObserver' in window)) {
      // Fallback: show all
      all.forEach(({ el }) => el.classList.add('is-visible'));
      return;
    }
    const io = new IntersectionObserver(function (entries) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    all.forEach(({ el }) => io.observe(el));
  })();

  // -------------------------------------------------------------
  // Nav: add 'scrolled' class after the page is scrolled past 30px
  // -------------------------------------------------------------
  (function () {
    const nav = document.getElementById('nav');
    if (!nav) return;
    function onScroll() {
      nav.classList.toggle('scrolled', window.scrollY > 30);
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  })();

  // -------------------------------------------------------------
  // Active link highlighting based on the section in view
  // -------------------------------------------------------------
  (function () {
    const links = document.querySelectorAll('.nav-links a');
    if (!links.length) return;
    const map = {};
    links.forEach(a => {
      const id = a.getAttribute('href');
      if (id && id.startsWith('#')) {
        const target = document.querySelector(id);
        if (target) map[id] = a;
      }
    });
    const io = new IntersectionObserver(function (entries) {
      entries.forEach(entry => {
        const id = '#' + entry.target.id;
        if (entry.isIntersecting && map[id]) {
          links.forEach(a => a.classList.remove('active'));
          map[id].classList.add('active');
        }
      });
    }, { rootMargin: '-40% 0px -55% 0px', threshold: 0 });
    Object.keys(map).forEach(id => {
      const el = document.querySelector(id);
      if (el) io.observe(el);
    });
  })();

  // -------------------------------------------------------------
  // Smooth scroll for in-page anchors (offset for sticky nav)
  // -------------------------------------------------------------
  document.querySelectorAll('a[href^="#"]').forEach(function (a) {
    a.addEventListener('click', function (e) {
      const id = a.getAttribute('href');
      if (!id || id === '#') return;
      const target = document.querySelector(id);
      if (!target) return;
      e.preventDefault();
      const y = target.getBoundingClientRect().top + window.scrollY - 80;
      window.scrollTo({ top: y, behavior: 'smooth' });
      // Close mobile menu after clicking
      document.getElementById('mobileMenu')?.classList.remove('open');
    });
  });

  // -------------------------------------------------------------
  // Mobile menu drawer toggle
  // -------------------------------------------------------------
  (function () {
    const btn = document.getElementById('menuToggle');
    const menu = document.getElementById('mobileMenu');
    if (!btn || !menu) return;
    btn.addEventListener('click', function () {
      menu.classList.toggle('open');
    });
    menu.addEventListener('click', function (e) {
      if (e.target === menu) menu.classList.remove('open');
    });
  })();

  // -------------------------------------------------------------
  // Counter animation for stats (run once when visible)
  // -------------------------------------------------------------
  (function () {
    const cards = document.querySelectorAll('.stat-card');
    if (!cards.length) return;
    const io = new IntersectionObserver(function (entries) {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const numEl = entry.target.querySelector('.num');
        if (!numEl || numEl.dataset.done) return;
        numEl.dataset.done = '1';
        const raw = (numEl.textContent || '').trim();
        // Skip non-numeric cards like "100%"
        if (!/\d/.test(raw)) return;
        const hasPercent = raw.includes('%');
        const target = parseInt(raw.replace(/\D+/g, ''), 10);
        if (!target) return;
        let cur = 0;
        const step = Math.max(1, Math.ceil(target / 28));
        const tick = function () {
          cur = Math.min(target, cur + step);
          numEl.textContent = cur + (hasPercent ? '%' : '+');
          if (cur < target) requestAnimationFrame(tick);
          else numEl.textContent = raw; // restore original styling
        };
        tick();
        io.unobserve(entry.target);
      });
    }, { threshold: 0.5 });
    cards.forEach(c => io.observe(c));
  })();
</script>

<!-- ===== FAQ Modal ===== -->
<div id="faq" class="modal-backdrop" role="dialog" aria-modal="true" aria-labelledby="faq-title">
  <div class="modal">
    <button class="modal-close" aria-label="Close" onclick="closeModal('faq')">&times;</button>
    <h2 id="faq-title">Frequently Asked Questions</h2>
    <p class="modal-sub">Category: <strong><?php echo htmlspecialchars($APP_CATEGORY); ?></strong> · Operator: <strong><?php echo htmlspecialchars($PRICE_OPERATOR); ?></strong></p>

    <h3>1. How much does <?php echo htmlspecialchars($APP_NAME); ?> cost?</h3>
    <p>Only <strong>৳<?php echo htmlspecialchars($PRICE_DAILY_BDT); ?> per day</strong> (incl. Vat+SC+SD) for Robi and Cirkle users. Auto-renews daily until canceled. No monthly or yearly bundles — just one simple plan.</p>

    <h3>2. Which operators are supported?</h3>
    <p>Only <strong><?php echo htmlspecialchars($PRICE_OPERATOR); ?></strong> subscribers can subscribe. Other operators will be rejected by BDApps.</p>

    <h3>3. Where do I download the app?</h3>
    <p>Download the official APK from <a href="<?php echo htmlspecialchars($APK_DOWNLOAD_URL); ?>"><?php echo htmlspecialchars($APK_DOWNLOAD_URL); ?></a>. The app is available on Android only.</p>

    <h3>4. How do I unsubscribe?</h3>
    <p>Dial <strong><?php echo htmlspecialchars($USSD_UNSUBSCRIBE); ?></strong> from your Robi/Cirkle number, or use the Unsubscribe form on this page. Upon unsubscription you will be automatically logged out of the app and returned to the login page.</p>

    <h3>5. Who handles my subscription?</h3>
    <p>Subscriptions are managed by BDApps. All charges appear on your mobile bill. For support, contact <a href="mailto:support@bdapps.com">support@bdapps.com</a> or call +8809610999922.</p>

    <h3>7. What does the subscription response message say?</h3>
    <p>It includes the <strong><?php echo htmlspecialchars($APP_CATEGORY); ?></strong> category and the official APK download link.</p>
  </div>
</div>

<!-- ===== Privacy Modal ===== -->
<div id="privacy" class="modal-backdrop" role="dialog" aria-modal="true" aria-labelledby="privacy-title">
  <div class="modal">
    <button class="modal-close" aria-label="Close" onclick="closeModal('privacy')">&times;</button>
    <h2 id="privacy-title">Privacy Notice</h2>
    <p class="modal-sub">Last updated: <?php echo date('F Y'); ?></p>

    <h3>What we collect</h3>
    <p>We collect only your verified mobile number (used for subscription &amp; login) and the meal / water data you log inside the app.</p>

    <h3>What we do not collect</h3>
    <p>We do not collect your contacts, location, photos, or any other personal data outside what you explicitly log.</p>

    <h3>How subscription data is handled</h3>
    <p>Subscription status is verified directly with BDApps using your subscriber ID. We never store your password, OTP, or billing details.</p>

    <h3>Contact</h3>
    <p>Privacy questions: <a href="mailto:support@bdapps.com">support@bdapps.com</a> · +8809610999922.</p>
  </div>
</div>
</body>
</html>
