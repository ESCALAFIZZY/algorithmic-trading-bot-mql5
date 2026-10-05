//+------------------------------------------------------------------+
//|                                                GoldSniper_300.mq5|
//|                                        Busari Oluwafisayomi Ameen|
//+------------------------------------------------------------------+
#property copyright "Busari Oluwafisayomi Ameen"
#property version   "2.00"

#include <Trade\Trade.mqh>
CTrade trade;

//--- Input parameters
input double LotSize = 0.10;
input int StopLoss = 500;          
input int TakeProfit = 1000;       
input int FastEMA_Period = 9;      
input int SlowEMA_Period = 21;     
input int BaselineEMA_Period = 200; // The primary trend filter
input int StartHour = 8;            // London Session open (Server Time)
input int EndHour = 17;             // New York Session close (Server Time)

int fastEMA_handle, slowEMA_handle, baselineEMA_handle;

//+------------------------------------------------------------------+
int OnInit()
  {
   fastEMA_handle = iMA(_Symbol, _Period, FastEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   slowEMA_handle = iMA(_Symbol, _Period, SlowEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   baselineEMA_handle = iMA(_Symbol, _Period, BaselineEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   
   if(fastEMA_handle == INVALID_HANDLE || slowEMA_handle == INVALID_HANDLE || baselineEMA_handle == INVALID_HANDLE)
     {
      Print("Error initializing indicators.");
      return(INIT_FAILED);
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(fastEMA_handle);
   IndicatorRelease(slowEMA_handle);
   IndicatorRelease(baselineEMA_handle);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   // 1. Strict One-Trade Rule
   if(PositionsTotal() > 0) return;

   // 2. Time Filtering: Only execute during high-volume overlaps
   MqlDateTime time;
   TimeCurrent(time);
   if(time.hour < StartHour || time.hour >= EndHour) return;

   // 3. Indicator Arrays
   double fastEMA[], slowEMA[], baselineEMA[];
   ArraySetAsSeries(fastEMA, true);
   ArraySetAsSeries(slowEMA, true);
   ArraySetAsSeries(baselineEMA, true);
   
   // Copy the last 3 candles for the crossover, and the current candle for the baseline
   CopyBuffer(fastEMA_handle, 0, 0, 3, fastEMA);
   CopyBuffer(slowEMA_handle, 0, 0, 3, slowEMA);
   CopyBuffer(baselineEMA_handle, 0, 0, 1, baselineEMA);
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

   // 4. FILTERED SCALPING LOGIC 
   
   // BUY SIGNAL: 
   // - Fast EMA was below Slow EMA 2 candles ago, but is now above it (Clean Cross Up)
   // - Current price is ABOVE the 200 EMA (Uptrend)
   if(fastEMA[2] <= slowEMA[2] && fastEMA[1] > slowEMA[1] && Ask > baselineEMA[0])
     {
      trade.Buy(LotSize, _Symbol, Ask, Ask - (StopLoss * point), Ask + (TakeProfit * point), "GS300 V2 BUY");
     }
     
   // SELL SIGNAL: 
   // - Fast EMA was above Slow EMA 2 candles ago, but is now below it (Clean Cross Down)
   // - Current price is BELOW the 200 EMA (Downtrend)
   else if(fastEMA[2] >= slowEMA[2] && fastEMA[1] < slowEMA[1] && Bid < baselineEMA[0])
     {
      trade.Sell(LotSize, _Symbol, Bid, Bid + (StopLoss * point), Bid - (TakeProfit * point), "GS300 V2 SELL");
     }
  }
//+------------------------------------------------------------------+