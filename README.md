# Record-Conjurer

Record-Conjurer is an object-relational mapper inspired by Ruby on Rails' Active Record. This ORM allows Ruby classes to connect to SQLite3 relational database tables. A sample database is provided for experimentation in Pry.

## Setup (for sample DB)
1. Clone the repo
2. Run `bundle install` in the root directory
3. Run `bundle exec pry` in the root directory
4. Have fun poking about!

## Sample Database Schema
*Database is a subset of the [chinook database](https://github.com/lerocha/chinook-database)*

### `Albums`
| column name       | data type     | details                   |
|:------------------|:-------------:|:--------------------------|
| `AlbumId`         | integer       | not null, primary key     |
| `Title`           | nvarchar(160) | not null, indexed, unique |
| `ArtistId`        | integer       | not null, foreign key     |

### `Artists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `ArtistId`        | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `Genres`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `GenreId`         | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `media_types`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `MediaTypeId`     | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `Playlists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `PlaylistId`      | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `playlist_tracks`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `PlaylistId`      | integer       | not null, foreign key          |
| `TrackId`         | integer       | not null, foreign key          |

### `Tracks`
| column name       | data type     | details                             |
|:------------------|:-------------:|:------------------------------------|
| `TrackId`         | integer       | not null, primary key               |
| `name`            | nvarchar(200) | not null, indexed, unique           |
| `AlbumId`         | integer       | foreign key                         |
| `MediaTypeId`     | integer       | not null, foreign key               |
| `GenreId`         | integer       | foreign key                         |
| `Composer`        | nvarchar(220) |                                     |
| `Milliseconds`    | integer       | not null                            |
| `Bytes`           | integer       |                                     |
| `UnitPrice`       | numeric(10,2) | not null                            |

## Future Implementations
Forthcoming features include:
+ Updates to this README.md file
