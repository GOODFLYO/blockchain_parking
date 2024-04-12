<template>
  <div class="nav">
    <nav>
      <router-link to="/" class="css-button-sliding-to-top--green"
        >首页</router-link
      >

      <router-link to="/register" class="css-button-sliding-to-top--green"
        >注册</router-link
      >

      <router-link to="/linkwallet" class="css-button-sliding-to-top--green"
        >连接钱包</router-link
      >
      <router-link to="/gotouseparkinghome" class="css-button-sliding-to-top--green">
        停车场功能
      </router-link>
    </nav>
  </div>
</template>

<script>
export default {
  name: "Nav",
};
</script>
<style>
a {
  text-decoration: none;
  text-align: center;
  /* 垂直居中 */
  line-height: 40px;
}
.css-button-sliding-to-top--green {
  min-width: 130px;
  height: 40px;
  color: #fff;
  padding: 5px 10px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  display: inline-block;
  outline: none;
  border-radius: 5px;
  z-index: 0;
  background: #fff;
  overflow: hidden;
  border: 2px solid #57cc99;
  color: #57cc99;
}
.css-button-sliding-to-top--green:hover {
  color: #fff;
}
.css-button-sliding-to-top--green:hover:after {
  height: 100%;
}
.css-button-sliding-to-top--green:after {
  content: "";
  position: absolute;
  z-index: -1;
  transition: all 0.3s ease;
  left: 0;
  bottom: 0;
  height: 0;
  width: 100%;
  background: #57cc99;
}
</style>
