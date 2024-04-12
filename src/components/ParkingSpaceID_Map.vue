<template>
  <div class="ParkingSpaceID_Map toolsView">
    <button @click="parkingSpaceID_Map" class="css-button-arrow--red">
      获取车位信息
    </button>
    <input type="text" v-model="id" placeholder="请输入车位ID " />
    <p>{{ info }}</p>
    <p>主人是：{{ info1 }}</p>
    <p>租用人是：{{ info2 }}</p>
    <p>车位状态是：{{ info3 }}</p>
    <p>开始租用时间是：{{ info4 }}</p>
    <p>租用时间是：{{ info5 }}</p>
  </div>
</template>

<script>
import { ethers } from "ethers";

export default {
  name: "ParkingSpaceID_Map",
  data() {
    return {
      id:"",
      info: "",
      info1: "",
      info2: "",
      info3: "",
      info4: "",
      info5: "",
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
      // 代币合约信息
      const zpayAddress = "0x4078f13fD4a21BF4F2d89ebbdb0A735F2fE9A934";
      const zpayABI = this.zpayABI_str;

      // 停车场合约信息
      const bpAddress = "0xA3646F20D83CD4EB4d5cB334135fA9fc52c2D08E";
      const bpABI = this.bpABI_str;

      const wallet = new ethers.providers.Web3Provider(window.ethereum);
      // 创建合约实例
      const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
      const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);

      return { zpayContract, bpContract };
    },
    /* ==============不消耗gas============== */

    // 管理员查看合约金额(用户充值的eth)
    async parkingSpaceID_Map() {
      await this.linkWallet();
      const { bpContract } = await this.createContractWithSigner();
      try {
        this.info1 = await bpContract.parkingSpaceID_owner(this.id);
        this.info2 = await bpContract.parkingSpaceID_bookbyer(this.id);
        this.info3 = await bpContract.parkingSpaceID_occupied(this.id);
        this.info4 = await bpContract.parkingSpaceID_starttime(this.id);
        this.info5 = await bpContract.parkingSpaceID_duration(this.id);
      } catch (error) {
        this.info = error;
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
