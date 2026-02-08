import { reactRouter } from "@react-router/dev/vite";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";
import wasm from "vite-plugin-wasm";

export default defineConfig({
  plugins: [tailwindcss(), reactRouter(), tsconfigPaths(), wasm()],
  base: process.env.GH_PAGES ? "/interlocking/geographical-interlocking/" : "/",
});
