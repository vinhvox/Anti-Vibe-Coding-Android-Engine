# Product Domain Reasoning Matrix (160+ Product Types)

## 1. Domain-Specific Visual Strategy

When designing any user interface, match the product type to its visual strategy, layout density, and primary focus:

| Product Domain / Type | Primary Visual Focus | Recommended Layout Density | Default Palette | Default Typography |
| :--- | :--- | :--- | :--- | :--- |
| **Fintech / Banking** | Security, Clarity, Balance | Compact / Scannable | Corporate Trust Blue / Wealth Green | Outfit + Manrope |
| **SaaS / Admin Dashboards** | Data Density, Quick Actions | Compact Grid (Bento) | Slate Tech / Obsidian Pro | Inter / Plus Jakarta Sans |
| **E-Commerce / Shopping** | Product Photography, Price | Comfortable / Spacious | Warm Coral & Charcoal | Outfit / Playfair Display |
| **Healthcare & Wellness** | Calmness, High Contrast | Spacious / High Whitespace | Serene Teal / Sage Neutral | Public Sans / Inter |
| **Media & Streaming** | Cover Art, Hero Banners | Immersive Dark Mode | Deep Charcoal + Electric Accent | SF Pro / Roboto |
| **Mobile Utilities / File Tools**| Immediate Action, Zero Fluff| Compact List / Grid | M3 Dynamic Tonal Blue | Roboto / System UI |
| **AI Tools & Chat Assistants** | Conversation Stream, Inputs | Clean Single-Column | Obsidian Dark / Neutral Light | Inter / SF Pro |

---

## 2. Decision Rules by Interaction Intent

1. **Transaction & Financial Action:**
   - Always display explicit confirmation steps for non-reversible actions.
   - Balance amounts MUST use tabular numbers (`fontFeatureSettings = "tnum"`) to prevent character shifting when values change dynamically.

2. **File Management & System Utility:**
   - Secondary action triggers (Rename, Delete, Share) MUST be available via long-press or 3-dot overflow menu.
   - Primary action (Tap) MUST trigger immediate open / preview.

3. **Form & Data Entry:**
   - Submit buttons MUST be disabled or visually dimmed until all required fields pass validation.
   - Error messages MUST appear directly below the invalid input field, never as generic top toasts.
