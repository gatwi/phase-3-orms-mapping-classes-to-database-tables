class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id =id # a song gets an id once saved into the database, therefore why it's first initialized as nil.
    @name = name
    @album = album
  end

  def self.create_table #crafts SQL statements to create a table with columns for attributes of individual instance of Song class.
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  # inserting a song using the save method!
  # use of bound parameters ? to differentiate from SQL injections.
  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)   
    SQL

    DB[:conn].execute(sql, self.name, self.album)

      # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self

  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end
