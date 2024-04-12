import { createRouter, createWebHashHistory } from "vue-router";
import Index from "../views/IndexHome.vue";
import Register from "../views/RegisterHome.vue";
import LinkWallet from "../views/LinkWalletHome.vue";
import GoToUsePakingHome from "../views/GoToUsePakingHome.vue";

const routes = [
  {
    path: "/",
    name: "index",
    component: Index,
  },
  {
    path: "/register",
    name: "register",
    component: Register,
  },

  {
    path: "/linkwallet",
    name: "linkallet",
    component: LinkWallet,
  },
  {
    path: "/gotouseparkinghome",
    name: "gotouseparkinghome",
    component: GoToUsePakingHome,
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
