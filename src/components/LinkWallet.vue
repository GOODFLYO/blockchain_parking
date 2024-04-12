<template>
  <div class="LinkWallet toolsView">
    <button class="css-button-arrow--red" @click="handleWallet">
      {{ attention }}
    </button>
    <p>{{ address }}</p>
  </div>
</template>

<script>
export default {
  name: "LinkWallet",
  components: {},
  data() {
    return {
      attention: "连接钱包",
      islinked: "false",
      address: "",
    };
  },

  methods: {
    // 连接钱包
    handleWallet() {
      const that = this;
      try {
        that.islinked = window.ethereum.isConnected();
        console.log(that.islinked);

        if (that.islinked) {
          // that.disconnectWallet();
          that.connectWallet();
        } else {
          that.attention = "连接钱包";
          that.connectWallet();
        }
      } catch (error) {
        console.log(error);
      }
    },
    connectWallet() {
      if (typeof window.ethereum !== "undefined") {
        const okx = window.ethereum;
        console.log("okx已经安装了");
        try {
          okx.request({ method: "eth_requestAccounts" });

          this.address = okx.selectedAddress;
          this.attention = "钱包已连接";
        } catch (error) {
          console.log(error);
        }
      }
    },
    disconnectWallet() {
      this.address = okx.selectedAddress;
      window.ethereum.disconnect();
      this.attention = "连接钱包";
    },
  },
};
</script>
<style>
.toolsView {
  margin: 10px;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}
.css-button-arrow--red {
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
  overflow: hidden;
  border-radius: 5px;
  border: none;
  background-color: #ef233c;
}
.css-button-arrow--red:hover {
  border-radius: 5px;
  padding-right: 24px;
  padding-left: 8px;
}
.css-button-arrow--red:hover:after {
  opacity: 1;
  right: 10px;
}
.css-button-arrow--red:after {
  content: "\00BB";
  position: absolute;
  opacity: 0;
  font-size: 20px;
  line-height: 40px;
  top: 0;
  right: -20px;
  transition: 0.4s;
}
</style>
