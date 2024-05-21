<template>
    <div class="GetParikingSpaceOwner toolsView">
      <button @click="getParikingSpaceOwner" class="css-button-arrow--red">
        查看车位编号对应主人信息
      </button>
      <input type="text" v-model="id" placeholder="请输入车位编号" />
    </div>
    <p>{{ info }}</p>
  </template>
  
  <script>
  import { ethers } from "ethers";
  export default {
    name: "GetParikingSpaceOwner",
    data() {
      return {
        id:"",
        info: "",
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
        console.log("---以上正确---");
  
        const wallet = new ethers.providers.Web3Provider(window.ethereum);
        const signer = wallet.getSigner();
  
        // 创建合约实例
        const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
        const zpayContractWithSigner = zpayContract.connect(signer);
        const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);
        const bpContractWithSigner = bpContract.connect(signer);
  
        return { zpayContractWithSigner, bpContractWithSigner };
      },
  
      async getParikingSpaceOwner() {
        await this.linkWallet();
        const { bpContractWithSigner } = await this.createContractWithSigner();
  
        try {
          const tx = await bpContractWithSigner.getParikingSpaceOwner(this.id);
          await tx.wait();
          console.log("添加成功");
          this.info = "添加成功";
        } catch (error) {
          this.info = error;
          console.error("失败:", error);
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
  