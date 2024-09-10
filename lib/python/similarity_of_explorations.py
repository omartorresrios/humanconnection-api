from sentence_transformers import SentenceTransformer, util
import sys
model = SentenceTransformer("all-MiniLM-L6-v2")

baseNote = sys.argv[1]
rawNotes = sys.argv[2].strip('{}').split()
notesDict = {}
similarNotes = []

for raw in list(rawNotes):
  raw = raw.replace('\\', ' ')
  key = raw.split('=>')[0]
  value = raw.split('=>')[1].strip(',')
  notesDict[key] = value

noteDocsDict = dict(zip(notesDict.keys(), notesDict.values()))
encodedBaseNote = model.encode(baseNote)

for id, body in noteDocsDict.items():
  encodedNote = model.encode(body)
  similarity = util.cos_sim(encodedBaseNote, encodedNote)
  if similarity > 0.50:
    similarNotes.append(id)

print(similarNotes)