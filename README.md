# algorithmic-trading-bot-mql5
"A quantitative algorithmic trading Expert Advisor (EA) built in MQL5 for MetaTrader 5, featuring genetic algorithm optimization, closed-candle execution logic, and strict risk-management filters

GoldSniper_300 Quantitative Trading Bot
Overview
GoldSniper_300 is a fully automated algorithmic trading Expert Advisor (EA) engineered in MQL5 for the MetaTrader 5 (MT5) platform. Designed specifically for the XAUUSD (Gold) market on the M5 timeframe, the bot utilizes moving average crossovers governed by strict baseline trend filters and session-specific time constraints to execute high-probability trades.

Algorithm Architecture
Language: MQL5 (C++ based)

Execution Logic: Evaluates index data strictly on closed candles to eliminate mid-candle repainting and prevent false signal generation.

Trend Filtering: Integrates a 160-period Baseline Exponential Moving Average (EMA) to ensure trades are only executed in the direction of the macro-trend.

Session Constraints: Trading window is mathematically restricted to high-volume market overlap hours (05:00 to 17:00 Server Time / London to New York sessions) to avoid low-liquidity spread widening.

Quantitative Performance & Risk Management
The algorithm was stress-tested and refined using MT5's Genetic Algorithm Optimizer over a 3-month historical tick-data simulation. The optimization prioritized risk-adjusted returns over raw profit, yielding the following performance metrics:

Sharpe Ratio: 10.67 (Indicating exceptional risk-adjusted performance)

Maximum Equity Drawdown: 5.06% ($596.10 on a $10,000 baseline)

Expected Payoff: 6.69 per trade

Recovery Factor: 2.85

Optimization Methodology
Initial parameters resulted in high market exposure and excessive drawdown. By deploying MT5's Genetic Algorithm on the Strategy Tester, thousands of mathematical combinations were simulated to identify the optimal BaselineEMA_Period (160) and StartHour (5). This data-driven optimization successfully reduced total trade volume by over 30% while simultaneously improving the Expected Payoff and cutting the maximum drawdown in half.

Disclaimer
This repository contains the source code and backtest reports for portfolio demonstration purposes only. It does not constitute financial advice
