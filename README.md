# Analiza zachorowalności na Raka Płuc
<img width="1327" height="742" alt="Dashboard_Lung_Cancer_F" src="https://github.com/user-attachments/assets/65219c96-1811-4503-bd5f-7ea353bca67d" />
<img width="1327" height="741" alt="Dashboard_Lung_Cancer_M" src="https://github.com/user-attachments/assets/ba741115-3b8c-414f-b3ce-f957a056a2fc" />

## Cel projektu
Głównym celem analizy było zidentyfikowanie trendów zachorowalności na raka płuc w oparciu o wiek, płeć, geografię oraz status palacza. Dashboard został zaprojektowany z naciskiem na przejrzysty intrfejs "Light Mode", dedykowany branży medycznej. 
## Wykorzystane technologie
* **PostgreSQL (pgAdmin):** Definiowanie struktury bazy danych oraz import dużych zbiorów danych medycznych z pliku CSV.
* **SQL:** Tworzenie zapytań strukturalnych z użyciem klauzuli 'WITH' oraz zaawansowanych funkcji agregujących do wyliczania mediany 'PERCENTILE_CONT'.
* **Power BI:** Projektowanie interfejsu (Light mode) dedykowanego branży medycznej oraz wdrażanie niestandardowych etykiet narzędzi (Report Page Tooltips) dla wykresów trendów.
* **Power Query:** Transformacja danych demograficznych, tworzenie kolumn warunkowych oraz rozwiązanie problemów architektonicznych (eliminacja błędu Circular Dependency poprzez twardą indeksację).
* **Modelowanie danych:** Tworzenie tabel słownikowych i budowa relacji zapewniających prawidłowy przepływ filtrów. 
* **DAX:** Budowa miar analitycznych i wskaźników KPI (np. procentowy udział palaczy).

## Wyzwania techniczne i zastosowane rozwiązania
Podczas realizacji tego projektu napotkałam i skutecznie rozwiązałam kilka złożonych problemów analitycznych oraz architektonicznych:
* **Przygotowanie środowiska i importowanie danych (PostgreSQL / pgAdmin):**
  Pracę rozpoczęłam od prawidłowego zaprojektowania struktury bazy danych. Wyzwaniem było napisanie skryptu DDL ('CREATE TABLE'), który precyzyjnie definiował typy danych dla specyficznych atrybutów medycznych, a następnie bezbłędny import dużej paczki danych z surowego pliku CSV za pomocą narzędzi pgAdmin, dbając o integralność danych i formaty dat.
* **Zaawansowana analityka w SQL (klauzula WITH i Mediana):**
  Aby odciążyć silnik Power BI, część ciężkich obliczeń przeniosłam na stronę bazy danych. Używając zapytań strukturalnych (klauzula 'WITH'), pogrupowałam dane według położenia geograficznego i statusu palacza. Wykorzystałam również zaawansowane funkcje SQL do precyzyjnego wyliczenia **mediany wieku w momencie diagnozy**, dostarczając do raportu gotowe podsumowania.
* **Kategoryzacja przedziałów wiekowych i błąd "Circular Dependency":**
  Przedziały wiekowe (np. "40-49") stworzyło początkowo problem przy sortowaniu wykresów, a próba wymuszenia własnej kolejności za pomocą kolumny obliczeniowej DAX wywołało błąd zależności cyklicznej (Circular Dependency). Rozwiązałam ten problem przenosząc logikę zliczania na wcześniejszy etap - do **Power Query**. Zbudowałam tam kolumnę warunkową, tworząc tzw. "twardą" indeksację, która ustabilizowała model.
* **Modelowanie danych (Tabela słownikowa):**
  Raport opierał się na danych zasilających różne wizualizacje. Aby umożliwić odbiorcy filtrowanie całego dashboardu (wszystkich wykresów) za pomocą jednego wspólnego przycisku wyboru płci, zaprojektowałam tabelę słownikową. Stworzyło to poprawną architekturę relacyjną (most między tabelami), pozwalając filtrom swobodnie przepływać przez cały model.
* **Niestandardowe Etykiety Narzędzi (Report Page Tooltip) dla wielowymiarowej analizy:**
Aby utrzymać sterylny i czytelny interfejs ("Light Mode"), zrezygnowałam z nadmiaru małych wykresów na głównym ekranie na rzecz ukrytych stron raportu, które pełnią funkcję interaktywnych dymków. Wdrożyłam to rozwiązanie w dwóch kluczowych obszarach analitycznych:
1. **Analiza geograficzna:** Najechanie na konkretne państwo na wykresie słupkowym dynamicznie generuje mini-dashboard z podziałem na status palacza wyłącznie dla wybranego regionu.
2. **Analiza Trendów w Czasie:** Wykres liniowy pokazuje historyczną zachorowalność z podziałem a płeć. Po najechaniu na dany rok włącza się Tooltip pokazujący dokładną strukturę pacjentów (aktywni palacze, byli palacze i osoby niepalące) zdiagnozowanych w tamtym okresie.

Działanie Tooltipów na wykresie geograficznym i liniowym
<img width="837" height="437" alt="Dashboard_Lung_Cancer_tooltip_panstwa" src="https://github.com/user-attachments/assets/87433aad-73b3-4c62-8442-e4d39a409506" />

<img width="822" height="432" alt="Dashboard_Lung_Cancer_tooltip_zachorowalnosc" src="https://github.com/user-attachments/assets/e663d3b9-2138-4115-ab83-c6bc790975bd" />

## Struktura Dashboardu i KPI
Interfejs użykownika został zaprojektowany w sterylnym, medycznym układzie "Light Mode", zapewniając maksymalną czytelność danych wrażliwych. 

**Kluczowe wskaźniki efektywności (KPI):**
* Całkowita ilość zdiagnozowanych pacjentów z podziaem na płeć
* Mediana wieku w momencie diagnozy z podziałem na płeć
* Procentowy udział osób niepalących wśród zdiagnozowanych
* 
**Analiza wizualna (Wykresy):**
* **Analiza geograficzna (TOP 10 państw):** Wykres pokazujący wolumen zachorowań na świecie (wspierany Tooltipem ze szczegółowym podziałem na status palacza dla każdego kraju).
* **Dynamika Historyczna:** Wykres liniowy prezentujący trend diagnoz na przestrzeni lat (wspierany Tooltipem pokazującym strukturę pacjentów: palacze, byli palacze i osoby niepalące w danym roku).
* **Rozkład Demograficzny:** Analiza zachorowalności według grup wiekowych (pokazująca wyraźny skok po 50 roku życia).
* **Profil Behawioralny:** Struktura pacjentów według historii nikotynowej i płci.
  
## Wnioski
Analiza interaktywnego dashboardu pozwoliła na wyodrębnienie następujących trendów:
* **Skok zachorowalności po 50 roku życia:**
Analiza struktury demograficznej ujawnia wyraźny punkt krytyczny - wzrost diagnoz u pacjentów którzy przekroczyli 50 rok życia. Wiek ten stanowi wyraźną granicę wzrostu ryzyka zachorowania, co stanowi kluczową informację dla programów badań przesiewowych i profilaktyki.
* **Dominacja osób niepalących w strukturze diagnoz:**
  Wbrew powszechnym skojarzeniom z nowotworem płuc, eksploracja danych wykazuje, że największą grupę zdiagnozowanych pacjentów w badanej populacji stanowią osoby niepalące. Ten trend utrzymuje się jako dominujący zarówno w grupie mężczyzn, jak i kobiet.
* **Specyfika profilu zachorowań u kobiet:**
  Pogłębiona analiza wskazuje, że wśród kobiet odsetek diagnoz u osób bez historii nikotynowej jest szczególnie wysoki i wyraźnie przeważa nad pozostałymi kategoriami (aktywni palacza i byli palacze). Sugeruje to silniejszy wpływ innych czynników ryzyka (np. genetycznych lub środowiskowych) specyficznych dla tej grupy pacjentek.
* **Zróżnicowanie geograficzne i behawioralne:**
  Zestawienie TOP 10 państw ujawnia, że najwyższą bezwzględną liczbę zachorowań notuje się w Japonii oraz Malezji i Nowej Zelandii. Pogłębiona analiza wewnątrz etykiety narzędzi wskazuje, że struktura pacjentów jest podobna. Ponad 60% diagnoz stanowią osoby niepalące, co może sugerować wpływ innych czynników środowiskowych np. zanieczyszczenia powietrza.
* **Dynamika historyczna i zmiana struktury pacjentów:**
  Analiza trendu w czasie pokazuje rosnącą tendencję ogólnej liczby diagnoz na przestrzeni badanych lat. Analiza warstwy szczegółowej ujawnia interesującą zmianę: wciągu ostatnich 6 lat zauważalny jest wzrost osób niepalących wśród nowo zdiagnozowanych pacjentów.
* **Mediana wieku zachorowania:**
  Obliczenia po stronie bazy danych wykazują, że mediana wieku w momencie diagnozy różni się u kobiet i mężczyzn. Wśród kobiet niepalących wynosi 58 lat w przypadku mężczyzn 62 lata.
