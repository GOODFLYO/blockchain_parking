<template>
  <div class="GetBalanceOfContract toolsView">
    <button @click="getBalanceOfContract" class="css-button-arrow--red">
      获取合约余额
    </button>
    <p>地址是：{{ address }}</p>
    <p>合约eth数量是：{{ balance }}</p>
  </div>
</template>

<script>
import { ethers } from "ethers";

// import { fs } from "fs";
export default {
  name: "GetBalanceOfContract",
  data() {
    return {
      balance: 0,
      address: 0,
      address: "",
      zpayABI_str: require("../assets/zpay.json"),
      bpABI_str: require("../assets/blockchainParking.json"),
    };
  },
  methods: {
    async linkWallet() {
      // 检查浏览器是否有okx钱包
      if (!window.ethereum) {
        alert("请先安装okx钱包");
      } else {
        const okx = window.ethereum;

        // 检测钱包是否连接
        if (!okx.isConnected()) {
          // alert("请先连接钱包");
          try {
            const accounts = await okx.request({
              method: "eth_requestAccounts",
            });
            this.address = accounts[0];
            console.log("连接成功", accounts[0]);
          } catch (error) {
            console.error("连接失败:", error);
          }
        } else {
          const accounts = await okx.request({
            method: "eth_requestAccounts",
          });
          this.address = accounts[0];
          console.log("钱包已连接", okx.selectedAddress);
        }
      }
    },
    async createContractWithSigner() {
      // 通证合约信息
      const zpayAddress = "0x1282507a50Ed1e3eF9f56d8bc626B12DB3a04641";
      const zpayABI = this.zpayABI_str;

      // 停车场合约信息
      const bpAddress = "0x1658A0A0Cb7f5c5908EF57B4325573f23dEf0238";
      const bpABI = this.bpABI_str;

      const wallet = new ethers.providers.Web3Provider(window.ethereum);
      // 创建合约实例
      const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
      const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);

      return { zpayContract, bpContract };
    },
    /* ==============不消耗gas============== */

    // 管理员查看合约金额(用户充值的eth)
    async getBalanceOfContract() {
      await this.linkWallet();
      const { bpContract } = await this.createContractWithSigner();
      try {
        const balance = await bpContract.getBalanceOfContract();
        this.balance = JSON.parse(balance) ;
        console.log("合约余额:", balance, "wei");
      } catch (error) {
        console.log("获取失败:", error);
      }
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
