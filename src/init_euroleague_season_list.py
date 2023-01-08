# Title: Lookup Game-Code Game creation 

# Immport libraries 
import pandas as pd


# Season 2007-08
lkpSeason07 = pd.DataFrame(
            {'game_id': list(range(1, 232)),
             'year_id': ['2007'] * 231, 
             'season_id': ['2007-08'] * 231
            }
        )

# Season 2008-09
lkpSeason08 = pd.DataFrame(
            {'game_id': list(range(1, 189)),
             'year_id': ['2008'] * 188, 
             'season_id': ['2008-09'] * 188
            }
        )

# Season 2009-10
lkpSeason09 = pd.DataFrame(
            {'game_id': list(range(1, 189)),
             'year_id': ['2009'] * 188, 
             'season_id': ['2009-10'] * 188
            }
        )

# Season 2010-11
lkpSeason10 = pd.DataFrame(
            {'game_id': list(range(1, 190)),
             'year_id': ['2010'] * 189, 
             'season_id': ['2010-11'] * 189
            }
        )

# Season 2011-12
lkpSeason11 = pd.DataFrame(
            {'game_id': list(range(1, 189)),
             'year_id': ['2011'] * 188, 
             'season_id': ['2011-12'] * 188
            }
        )

# Season 2012-13
lkpSeason12 = pd.DataFrame(
            {'game_id': list(range(1, 254)),
             'year_id': ['2012'] * 253, 
             'season_id': ['2012-13'] * 253
            }
        )

# Season 2013-14
lkpSeason13 = pd.DataFrame(
            {'game_id': list(range(1, 254)),
             'year_id': ['2013'] * 253, 
             'season_id': ['2013-14'] * 253
            }
        )

# Season 2014-15
lkpSeason14 = pd.DataFrame(
            {'game_id': list(range(1, 252)),
             'year_id': ['2014'] * 251, 
             'season_id': ['2015-15'] * 251
            }
        )

# Season 2015-16
lkpSeason15 = pd.DataFrame(
            {'game_id': list(range(1, 251)),
             'year_id': ['2015'] * 250, 
             'season_id': ['2015-16'] * 250
            }
        )

# Season 2016-17
lkpSeason16 = pd.DataFrame(
            {'game_id': list(range(1, 264)),
             'year_id': ['2016'] * 263, 
             'season_id': ['2016-17'] * 263
            }
        )

# Season 2017-18
lkpSeason17 = pd.DataFrame(
            {'game_id': list(range(1, 261)),
             'year_id': ['2017'] * 260, 
             'season_id': ['2017-18'] * 260
            }
        )

# Season 2018-19
lkpSeason18 = pd.DataFrame(
            {'game_id': list(range(1, 261)),
             'year_id': ['2018'] * 260, 
             'season_id': ['2018-19'] * 260
            }
        )

# Season 2019-20
lkpSeason19 = pd.DataFrame(
            {'game_id': list(range(1, 261)),
             'year_id': ['2019'] * 260, 
             'season_id': ['2019-20'] * 260
            }
        )

# Season 2020-21
lkpSeason20 = pd.DataFrame(
            {'game_id': list(range(1, 329)),
             'year_id': ['2020'] * 328, 
             'season_id': ['2020-21'] * 328
            }
        )

# Season 2021-22
lkpSeason21 = pd.DataFrame(
            {'game_id': list(range(1, 331)),
             'year_id': ['2021'] * 330, 
             'season_id': ['2021-22'] * 330
            }
        )

# Season 2022-23
lkpSeason22 = pd.DataFrame(
            {'game_id': list(range(1, 73)),
             'year_id': ['2022'] * 72, 
             'season_id': ['2022-23'] * 72
            }
        )

# Combine in one lookup
lkpSeasons = pd.concat([lkpSeason07, lkpSeason08, lkpSeason09, 
                        lkpSeason10, lkpSeason11, lkpSeason12, 
                        lkpSeason13, lkpSeason14, lkpSeason15,
                        lkpSeason16, lkpSeason17, lkpSeason18,
                        lkpSeason19, lkpSeason20, lkpSeason21,
                        lkpSeason22])






