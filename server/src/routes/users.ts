import express, { Request, Response } from 'express'
import { getUserById, getUsers, updateUser } from '../controllers/users'
const router = express.Router()

router.get('/', getUsers as express.RequestHandler)
router.get('/:id', getUserById as express.RequestHandler)
router.put('/:id', updateUser as express.RequestHandler)

export default router
