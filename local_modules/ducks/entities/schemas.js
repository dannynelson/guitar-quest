import { normalize, Schema, arrayOf } from 'normalizr';

export const pieceSchema = new Schema('pieces', { idAttribute: '_id' })
export const userPieceSchema = new Schema('userPieces', { idAttribute: '_id' })
export const challengeSchema = new Schema('challenges', { idAttribute: '_id' })
