defmodule BlockScoutWeb.AddressCoinBalanceViewTest do
  use BlockScoutWeb.ConnCase, async: true

  alias BlockScoutWeb.AddressCoinBalanceView
  alias Explorer.Chain.Wei

  describe "format/1" do
    test "format the wei value in Seele" do
      wei = Wei.from(Decimal.new(1_340_000_000), :gwei)

      assert AddressCoinBalanceView.format(wei) == "13.4 Seele"
    end

    test "format negative values" do
      wei = Wei.from(Decimal.new(-1_340_000_000), :gwei)

      assert AddressCoinBalanceView.format(wei) == "-13.4 Seele"
    end
  end

  describe "delta_arrow/1" do
    test "return up pointing arrow for positive value" do
      value = Decimal.new(123)

      assert AddressCoinBalanceView.delta_arrow(value) == "▲"
    end

    test "return down pointing arrow for negative value" do
      value = Decimal.new(-123)

      assert AddressCoinBalanceView.delta_arrow(value) == "▼"
    end
  end

  describe "delta_sign/1" do
    test "return Positive for positive value" do
      value = Decimal.new(123)

      assert AddressCoinBalanceView.delta_sign(value) == "Positive"
    end

    test "return Negative for negative value" do
      value = Decimal.new(-123)

      assert AddressCoinBalanceView.delta_sign(value) == "Negative"
    end
  end

  describe "format_delta/1" do
    test "format positive values" do
      value = Decimal.new(1_340_000_000_000_000_000)

      assert AddressCoinBalanceView.format_delta(value) == "1.34 Seele"
    end

    test "format negative values" do
      value = Decimal.new(-1_340_000_000_000_000_000)

      assert AddressCoinBalanceView.format_delta(value) == "1.34 Seele"
    end
  end
end