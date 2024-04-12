<template>
  <Zpay></Zpay>
  <Operator></Operator>
  <TotalPakingSpace></TotalPakingSpace>
  <GetUserBalance></GetUserBalance>
  <GetBalanceOfContract></GetBalanceOfContract>
  <NowParkingNumber></NowParkingNumber>
  <ZTbalance></ZTbalance>
  <ParkingSpaceID_Map></ParkingSpaceID_Map>
  <AddParkingSpace></AddParkingSpace>

  <BookParkingSpace></BookParkingSpace>
  <CancelBookParkingSpace></CancelBookParkingSpace>
  <DeleteParkingSpace></DeleteParkingSpace>
  <Withdraw></Withdraw>
  <Withdraw_Operator></Withdraw_Operator>
  <AddTotalParkingSpace></AddTotalParkingSpace>
</template>

<script>
import Zpay from "@/components/Zpay.vue";
import Operator from "@/components/Operator.vue";
import TotalPakingSpace from "@/components/TotalPakingSpace.vue";
import GetBalanceOfContract from "../components/GetBalanceOfContract.vue";
import GetUserBalance from "@/components/GetUserBalance.vue";
import NowParkingNumber from "@/components/NowParkingNumber.vue";
import ZTbalance from "@/components/ZTbalance.vue";
import ParkingSpaceID_Map from "@/components/ParkingSpaceID_Map.vue";
import Deposit from "../components/Deposit.vue";
import AddTotalParkingSpace from "@/components/AddTotalParkingSpace.vue";
import RegisterWith5wei from "@/components/RegisterWith5wei.vue";
import AddParkingSpace from "@/components/AddParkingSpace.vue";
import BookParkingSpace from "@/components/BookParkingSpace.vue";
import CancelBookParkingSpace from "@/components/CancelBookParkingSpace.vue";
import DeleteParkingSpace from "@/components/DeleteParkingSpace.vue";
import Withdraw from "@/components/Withdraw.vue";
import Withdraw_Operator from "@/components/Withdraw_Operator.vue";
export default {
  name: "GoToUsePakingHome",
  components: {
    Zpay,
    Operator,
    TotalPakingSpace,
    GetBalanceOfContract,
    GetUserBalance,
    NowParkingNumber,
    ZTbalance,
    ParkingSpaceID_Map,
    Deposit,
    RegisterWith5wei,
    AddParkingSpace,
    AddTotalParkingSpace,
    BookParkingSpace,
    CancelBookParkingSpace,
    DeleteParkingSpace,
    Withdraw,
    Withdraw_Operator,
  },
};
</script>
