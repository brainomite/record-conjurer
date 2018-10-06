# Record-Conjurer

Record-Conjurer is an object-relational mapper inspired by Ruby on Rails' Active Record. This ORM allows Ruby classes to connect to SQLite3 relational database tables. A sample database is provided for experimentation in Pry.

## Table of contents
- [Setup](https://github.com/brainomite/record-conjurer#setup-for-sample-db)
- [Usage](https://github.com/brainomite/record-conjurer#usage)
- [Things to Try](https://github.com/brainomite/record-conjurer#things-to-try)
- [Demo Classes](https://github.com/brainomite/record-conjurer#demo-classes)
- [Sample Database Schema](https://github.com/brainomite/record-conjurer#sample-database-schema)
- [Future Implementations](https://github.com/brainomite/record-conjurer#future-implementations)

## Setup (for sample DB)
1. Clone the repo
2. Run `bundle install` in the root directory
3. Run `bundle exec pry` in the root directory
4. Have fun poking about!

## Usage
All classes inherit from RecordConjurer, thus will have the following interfaces
- `::all` returns all of the records in the associated table as an array
- `::table_name` returns the name of the table use in the db
- `::new(field_hash)` will create a new instance and will set fields to value provided in the optional hash
- `::find(id)` returns a record with that id, or nil if not found
- `#save` will add a new record to the db with the values provided. Returns the new id.
- `#field_name` returns the value of the field for that record
- `#field_name=` sets the value of the field for that record
- `#update` saves that changes made to a record
- `#attributes` returns a hash with field:value pairs
- `#attribute_values` returns an array of all the values

## Things to Try

```ruby
  Artist.all #=> Array of artists
  Track.all #=> Array of tracks
  accept_band = Artist.find(2) #=> #<Artist:0x007fcbc01d7e80 @attributes={:id=>2, :Name=>"Accept"}>
  accept_band.albums #=> Array of albums belonging to accept_band
  aerosmith = Artist.where(name: "Aerosmith").first #=> #<Artist:0x007fcbbfaa5c20
                                                    #      @attributes={:id=>3, :Name=>"Aerosmith"}>
  aerosmith_album = aerosmith.albums.first  #=> #<Album:0x007fcbc11a5768
                                            #     @attributes={
                                            #       :id=>5,
                                            #       :Title=>"Big Ones",
                                            #       :ArtistId=>3}>
  aerosmith_album.tracks #=> Array of tracks
  song_where = {name: "Dude (Looks Like A Lady)"}
  song = Track.where(song_where).first  #=> #<Track:0x007fcbc144b210
                                        #      @attributes=
                                        #       {:id=>27,
                                        #        :Name=>"Dude (Looks Like A Lady)",
                                        #        :AlbumId=>5,
                                        #        :MediaTypeId=>1,
                                        #        :GenreId=>1,
                                        #        :Composer=>"Steven Tyler, Joe Perry, Desmond Child",
                                        #        :Milliseconds=>264855,
                                        #        :Bytes=>8679940,
                                        #        :UnitPrice=>0.99}>
  song.artist #=> #<Artist:0x007fcbc02c7f98 @attributes={:id=>3, :Name=>"Aerosmith"}>
  aerosmith.Name = 'not aerosmith' #=> "not aerosmith"
  aerosmith.update #=> 0
  Artist.find(3) #=> #<Artist:0x007f921bbae2d0 @attributes={:id=>3, :Name=>"not aerosmith"}>
  new_artist = Artist.new(Name: 'Sonic') #=> #<Artist:0x007f921bb3d5d0 @attributes={:Name=>"Sonic"}>
  new_artist.save #=> 276
  Artist.all.last #=> #<Artist:0x007f921b94f840 @attributes={:id=>276, :Name=>"Sonic"}>
```

## Demo Classes
*These are set up in demo.rb and autoloaded via .pryrc when pry is ran*
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
| `Title`           | nvarchar(160) | not null                  |
| `ArtistId`        | integer       | not null, foreign key     |

+ index on `ArtistId`
+ `ArtistID` references `Artists`

### `Artists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) | not null, indexed, unique      |

### `Genres`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) |                                |


### `media_types`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) |                                |

### `Playlists`
| column name       | data type     | details                        |
|:------------------|:-------------:|:-------------------------------|
| `id`              | integer       | not null, primary key          |
| `Name`            | nvarchar(120) |                                |

### `playlist_tracks`
| column name       | data type     | details                            |
|:------------------|:-------------:|:-----------------------------------|
| `PlayListId`      | integer       | not null, foreign key, primary key |
| `TrackId`         | integer       | not null, foreign key              |

+ index on `[:PlayListId, :TrackId], unique: true`
+ `PlayListId` references `Playlists`
+ `TrackId` references `Tracks`

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

+ `AlbumId` references `Albums`
+ `MediaTypeId` references `MediaTypes`
+ `GenreId` references `Genres`

## Future Implementations
Forthcoming features include:
+ The ability to select specific fields vs *
+ The ability to include relations to prevent n+1 queries
+ The abiltity to represetn `has_many_through` relations
+ The ability to see the generated SQL statements
