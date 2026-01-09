<h2>NFL 4th Down Decision Analysis (2024)</h2>

<p>
  This project analyzes NFL 4th down decision-making using 2024 play-by-play data to
  model when teams choose to “go for it” versus conservative options. The analysis
  focuses on how game context influences coaching risk-taking behavior.
</p>

<div style="background:#f3f4f6;padding:8px 12px;border-left:5px solid #2563eb;margin:18px 0 10px 0;">
  <strong>Objectives</strong>
</div>
<ul>
  <li>Identify key drivers of 4th down decisions</li>
  <li>Predict go-for-it behavior using logistic regression</li>
  <li>Quantify how score, field position, and game timing affect decision-making</li>
</ul>

<div style="background:#f3f4f6;padding:8px 12px;border-left:5px solid #eab308;margin:18px 0 10px 0;">
  <strong>Methodology</strong>
</div>
<ul>
  <li>Filtered 4th down plays and engineered a binary <code>go_for_it</code> variable</li>
  <li>Conducted exploratory analysis by quarter, score differential, and field position</li>
  <li>Applied chi-square testing and Cramer’s V for association analysis</li>
  <li>Built a logistic regression model in SAS with stepwise variable selection</li>
</ul>

<div style="background:#f3f4f6;padding:8px 12px;border-left:5px solid #16a34a;margin:18px 0 10px 0;">
  <strong>Key Results</strong>
</div>
<ul>
  <li>Teams punted ~50% of the time, indicating conservative tendencies</li>
  <li>Go-for-it rates doubled in the second half (32.5% in Q4 vs. 13–17% earlier)</li>
  <li>Trailing teams and shorter yards-to-go significantly increased aggression</li>
  <li>Final model achieved <strong>87.7% accuracy</strong> (c-statistic = <strong>0.877</strong>)</li>
</ul>

<div style="background:#f3f4f6;padding:8px 12px;border-left:5px solid #06b6d4;margin:18px 0 10px 0;">
  <strong>Tools</strong>
</div>
<p>
  <strong>SAS</strong>, Logistic Regression, Statistical Testing, NFL Play-by-Play Data
</p>

<div style="background:#f3f4f6;padding:8px 12px;border-left:5px solid #7c3aed;margin:18px 0 10px 0;">
  <strong>Files</strong>
</div>
<ul>
  <li><code>/reports/</code> – Final technical report (PDF)</li>
  <li><code>/notebooks/</code> – SAS analysis code</li>
</ul>
