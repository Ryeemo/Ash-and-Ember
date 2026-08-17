# Ash & Ember — install & share guide

This folder is a complete, standalone app. No build step, no app store.

## 1. Host it (pick one, both are free and take ~2 minutes)

**Netlify Drop (easiest)**
1. Go to https://app.netlify.com/drop
2. Drag this whole folder onto the page
3. You get a live URL like `https://random-name.netlify.app`

**GitHub Pages**
1. Create a new GitHub repo, upload these files
2. Repo Settings → Pages → set source to the main branch
3. Your URL will be `https://yourusername.github.io/reponame`

## 2. Share it with friends

Just send them the URL. When they open it on their phone:

- **iPhone (Safari):** tap the Share icon → "Add to Home Screen"
- **Android (Chrome):** tap the ⋮ menu → "Add to Home Screen" / "Install app"

It installs with a real icon, opens full-screen with no browser bar, and works offline after the first load.

## 3. Notes on how data works

- Ratings and any cigars you add are stored only on each person's own phone (browser local storage). Nobody's ratings sync to anyone else's — everyone builds their own profile.
- Recommendations work out of the box with no setup, using on-device taste matching.
- To get AI-written recommendation reasons and the "search for new releases" feature, each person can optionally add their own Anthropic API key in the Settings tab (gear icon, top right). It's stored only in their browser and used only for calls straight to Anthropic's API.

## 4. If you want it to feel more "native" later

A wrapper tool like Capacitor (capacitorjs.com) can package this exact folder into a real installable `.apk` — that requires the Android SDK installed on a computer, which isn't available in this build environment, but the web app itself needs zero changes to go that route.
