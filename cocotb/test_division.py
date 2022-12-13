import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.regression import TestFactory


class division_module:
    def __init__(self, dut):
        self.dut = dut
        dut.clkena.value = 1
        dut.reset.value = 1
        dut.dividend.value = 0
        dut.dividend_ena.value = 0

async def division_test(dut):
    tb = division_module(dut)
    ## Set clock ##
    period_clk = 10
    cocotb.start_soon(Clock(dut.clk, period_clk, "ns").start())
    clkedge = RisingEdge(dut.clk)

    await clkedge
    await clkedge

    dut.reset.value = 0
    dividend_value = 63
    remaind = 63%int(dut.m.value)
    int_value = 63//int(dut.m.value)
    await clkedge
    dut._log.info("Set dividend_ena in 1 state and send dividend value: ", dividend_value)
    dut.dividend_ena.value  = 1
    dut.dividend.value = dividend_value
    await clkedge
    dut.dividend_ena.value  = 0
    await RisingEdge(dut.result_valid)
    assert  remaind == int(dut.remaind.value), "Remaind not correct!"
    assert  int_value == int(dut.int_value.value), "Int value not correct!"
    dut._log.info("Valid data now")
    await Timer(50, units='ns')

tf = TestFactory(test_function=division_test)
tf.generate_tests()