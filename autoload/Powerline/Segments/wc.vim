let g:Powerline#Segments#wc#segments = Pl#Segment#Init(['wc',
	\ Pl#Segment#Create('characters', '%{Powerline#Functions#wc#Characters()}'),
	\ Pl#Segment#Create('fileinfo', '%F %{Powerline#Functions#wc#Characters()}')
  \ ])
