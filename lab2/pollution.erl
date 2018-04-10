%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. kwi 2018 13:20
%%%-------------------------------------------------------------------
-module(pollution).
-author("Ludwik Ciechański").
-record(station, {name, geoCords, measure}).
-record(measure, {temp, pm10, pm2d5, other=[]}).

%% API
-export([
  createMonitor/0,  %% tworzy i zwraca nowy monitor zanieczyszczeń;
  addStation/3,     %% dodaje do monitora wpis o nowej stacji pomiarowej (nazwa i współrzędne geograficzne), zwraca zaktualizowany monitor;
  addValue/5,       %% dodaje odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru, wartość), zwraca zaktualizowany monitor;
  removeValue/4,    %% usuwa odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru), zwraca zaktualizowany monitor;
  getOneValue/4,    %% zwraca wartość pomiaru o zadanym typie, z zadanej daty i stacji;
  getStationMean/3, %% zwraca średnią wartość parametru danego typu z zadanej stacji;
  getDailyMean/3    %% zwraca średnią wartość parametru danego typu, danego dnia na wszystkich stacjach;
]).

createMonitor() -> #{}.
addStation(Monitor, Name, GeoCords) ->
  %% TODO: sprawdzić czy stacja już istnieje
  maps:put(#station{name = Name, geoCords = GeoCords}, [], Monitor).

addValue(Station, Date, Type, Value, Monitor) -> [].
  %% TODO: pobrać pomiary dla danej stacji (sprawdzić czy istnieje)
  %% TODO: sprawdzić czy taki pomiar {Type, Value} już istnieje
  %% TODO: dodać pomiar

removeValue(Station, Date, Type, Monitor) -> [].
  %% TODO: analogicznie jak addValue
  %% TODO: usunąć pomiar

getOneValue(Station, Date, Type, Monitor) -> [].
  %% TODO: sprawdzić czy istnieje taka stacja
  %% TODO: sprawdzić czy istnieje pomiar {Date, Type}
  %% TODO: zwrócić wartość pomiaru

getStationMean(Station, Type, Monitor) -> [].
  %% TODO: sprawdzić czy istnieje taka stacja
  %% TODO: sprawdzić czy istnieje pomiar zadanego typu
  %% TODO: obliczyć i zwrócić średnią wartość pomiaru

getDailyMean(Type, Date, Monitor) -> [].
  %% TODO: pobrać wszystkie pomiary danego typu z danego dnia
  %% TODO: obliczyć i zwrócić średnią wartość pomiaru