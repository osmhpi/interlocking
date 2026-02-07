import type { Route } from "./+types/home";
import { Welcome } from "../welcome/welcome";

export function meta({}: Route.MetaArgs) {
  return [
    { title: "Formal Interlocking" },
  ];
}

export default function Home() {
  return <Welcome />;
}
