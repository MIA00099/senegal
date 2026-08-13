// ---------------------------------------------------------------------------
// Admin-only configuration. Loaded ONLY by admin.html — never by index.html —
// so this key isn't shipped to every visitor of the public site.
//
// Note on ImgBB: this key is usable by anyone who views admin.html's source,
// since it's a browser-side upload key (ImgBB doesn't offer a safer option for
// static sites). The worst case if it leaks is someone uploads junk images
// against your ImgBB quota — it does NOT grant access to your Supabase
// database or product data. If that ever becomes a problem, generate a new
// key at https://api.imgbb.com/ and swap it in here.
// ---------------------------------------------------------------------------

window.IMGBB_API_KEY = "09cdeba082daed1ba28382d7252059ab";
