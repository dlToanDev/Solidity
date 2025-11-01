import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";

describe("Sale", async function () {
  const { viem } = await network.connect();

  it("Should send 5% fee to owner when someone buys", async function () {
    // Deploy mock token (phải có 18 decimals)
    const token = await viem.deployContract("MockToken");

    // Deploy TokenSale
    const sale = await viem.deployContract("TokenSale", [token.address]);

    // Transfer token vào contract để làm hàng bán
    const totalSupply = 1_000_000n * 10n ** 18n; // 1 triệu token
    await token.write.transfer([sale.address, totalSupply]);

    // Buyer gửi 1 ETH để mua token
    const buyer = (await viem.getWalletClients())[1];
    const rate = 1000n; // 1 ETH = 1000 token
    const FEE = 5n;

    await sale.write.buyTokens({
      account: buyer.account,
      value: 1n * 10n ** 18n, // 1 ETH
    });

    // Tính toán giá trị kỳ vọng
    const tokensGross = rate * 10n ** 18n; // 1000 * 1e18
    const fee = (tokensGross * FEE) / 100n;
    const expectedBuyerTokens = tokensGross - fee;

    const buyerBal = await token.read.balanceOf([buyer.account.address]);
    const owner = await sale.read.owner();
    const ownerBal = await token.read.balanceOf([owner]);

    // So sánh chính xác theo 18 decimals
    assert.equal(buyerBal, expectedBuyerTokens);
    assert.equal(ownerBal, fee);
  });
});
