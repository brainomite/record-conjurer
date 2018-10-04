require_relative 'record_conjurer.rb'
DBConnection.reset # this will delete and or create the sample db.

class Album < RecordConjurer
  belongs_to :artist,
    primary_key: :id,
    foreign_key: :ArtistId
  has_many :tracks,
    primary_key: :id,
    foreign_key: :AlbumId
  finalize!
end

class Artist < RecordConjurer
  has_many :albums,
    primary_key: :id,
    foreign_key: :ArtistId
  finalize!
end

class Genre < RecordConjurer
  has_many :tracks,
    primary_key: :id,
    foreign_key: :GenreId
  finalize!
end

class MediaType < RecordConjurer
  has_many :tracks,
    primary_key: :id,
    foreign_key: :MediaTypeId
  finalize!
end

class Playlists < RecordConjurer
  has_many :playlist_tracks,
    primary_key: :id,
    foreign_key: :PlaylistId
  finalize!
end

class PlaylistTrack < RecordConjurer
  belongs_to :playlist,
    primary_key: :id,
    foreign_key: :PlaylistId
  belongs_to :track,
    primary_key: :id,
    foreign_key: :TrackId
  finalize!
end

class Track < RecordConjurer
  belongs_to :album,
    primary_key: :id,
    foreign_key: :AlbumId
  belongs_to :genre,
    primary_key: :id,
    foreign_key: :GenreId
  belongs_to :media_type,
    primary_key: :id,
    foreign_key: :MediaTypeId
  has_many :playlist_tracks,
    primary_key: :id,
    foreign_key: :TrackId
  finalize!
end
