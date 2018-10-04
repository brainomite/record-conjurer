# Record-Conjurer

Record-Conjurer is an object-relational mapper inspired by Ruby on Rails' Active Record. This ORM allows Ruby classes to connect to SQLite3 relational database tables. A sample database is provided for experimentation in Pry.

## Setup (for sample DB)
1. Clone the repo
2. Run `bundle install` in the root directory
3. Run `bundle exec pry` in the root directory
4. Have fun poking about!

## Usage
*class represents a class, class_instance represents and instance of the class, field_name represent a field*

All classes inherit from RecordConjurer
- class.all returns all of the records in the associated table as an array
- class.table_name returns the name of the table use in the db
- class.new(field_hash) will create a new instance and will set fields to value provided in the optional hash
- class_instance.save will add a new record to the db with the values provided. Returns the new id.
- class_instance.find(id) returns a record with that id, or nil if not found
- class_instance.field_name returns the value of the field for that record
- class_instance.field_name= sets the value of the field for that record
- class_instance.update saves that changes made to a record
- class_instance.attributes returns a hash with field:value pairs
- class_instance.attribute_values returns an array of all the values

## Demo Classes
*These are setup in demo.rb and autoloaded via .pryrc when pry is ran*
- `Albums`
- `Artists`
- `Generes`
- `MediaTypes`
- `Playlists`
- `PlaylistTracks`
- `Tracks`

## Sample Database Schema
*Database is a subset of the [chinook database](https://github.com/lerocha/chinook-database)*

### `Albums`
| column name       | data type     | details                   |
|:------------------|:-------------:|:--------------------------|
| `id`              | integer       | not null, primary key     |
| `Title`           | nvarchar(160) | not null, indexed, unique |
| `ArtistId`        | integer       | not null, foreign key     |

### `Artists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `Genres`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `media_types`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `Playlists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `playlist_tracks`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, foreign key          |
| `TrackId`         | integer       | not null, foreign key          |

### `Tracks`
| column name       | data type     | details                             |
|:------------------|:-------------:|:------------------------------------|
| `id`              | integer       | not null, primary key               |
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
