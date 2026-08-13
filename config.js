// ---------------------------------------------------------------------------
// Public configuration for Senegal Interior Design's live product catalog.
// Loaded by BOTH index.html (public site) and admin.html (private admin panel).
//
// IMPORTANT — key safety:
// - SUPABASE_ANON_KEY below is the "anon" / "public" key. It is DESIGNED to be
//   shipped to the browser — Supabase's Row Level Security policies (see
//   supabase-setup.sql) are what actually decide who can read/write data, not
//   secrecy of this key.
// - Never put your Supabase "service_role" key here, in admin.html, or in any
//   other file that gets served to visitors. That key bypasses every security
//   rule and grants full read/write/delete access to your entire database —
//   if it ever ends up in a browser-served file, anyone who views the page
//   source can take over the whole database.
// ---------------------------------------------------------------------------

window.SUPABASE_URL = "https://qnfpehciqoweivwbwkpc.supabase.co";

window.SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFuZnBlaGNpcW93ZWl2d2J3a3BjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY1NDY1MjcsImV4cCI6MjEwMjEyMjUyN30.4PkXNiDQ3pJku7N3eGh2-NfwJEFvZjNzpy81McXOgiU";
