## Dashboard Design & Iterative Improvements

The dashboard was developed iteratively, with a focus on improving analytical clarity, usability, and stakeholder interpretation. The following enhancements were applied after the initial build.

### 1. KPI Context and Performance Direction
Initially, the dashboard displayed total sales as a single headline metric. To provide immediate performance context, a second KPI was added to display the **latest month‑over‑month (MoM) sales change**.

This enables stakeholders to quickly assess whether performance is improving or declining, rather than viewing total revenue in isolation. Conditional formatting was applied to visually distinguish positive and negative change.

**Impact:**  
Stakeholders can immediately answer *“Are sales getting better or worse right now?”*

---

### 2. Time Granularity and Trend Clarity
Early versions of the trend and growth charts appeared visually noisy due to daily‑level variation. To address this, a dedicated **Month Start** date column was created and used across all time‑based visuals.

All relevant charts were standardised to a **monthly continuous time axis**, removing daily volatility and ensuring trends are presented at an appropriate analytical level.

**Impact:**  
Sales trends and MoM movements are smoother, easier to interpret, and aligned with how performance is typically reviewed by business stakeholders.

---

### 3. Month‑over‑Month Growth Reference Line
A horizontal reference line at zero was added to the MoM Growth chart. This provides a clear visual distinction between periods of positive and negative growth without introducing additional labels or clutter.

**Impact:**  
Performance shifts above and below zero are immediately visible, improving readability and reducing cognitive effort for the viewer.

---

### 4. Product Revenue Storytelling
The product performance chart was reframed to emphasise **revenue concentration**, rather than simply listing sales by product. This subtle change in framing highlights how revenue is distributed across products and supports prioritisation conversations.

**Impact:**  
The chart now communicates *importance and contribution*, rather than just comparison.

---

### 5. Visual Hierarchy and Layout Refinement
Final layout adjustments were applied to reinforce a clear narrative flow:
- Headline KPIs positioned as the primary entry point
- Product and regional drivers grouped logically
- Trend and growth visuals given sufficient space to support pattern recognition

**Impact:**  
The dashboard reads naturally from top to bottom and supports quick, intuitive interpretation.

---

These refinements improved the dashboard from a descriptive report into a decision‑support tool, aligning both the design and metrics with common BI best practices.
