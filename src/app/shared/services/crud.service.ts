import { Injectable } from '@angular/core';
import { Exercise } from '../services/exercise';
import {
  AngularFireDatabase,
  AngularFireList,
  AngularFireObject,
  snapshotChanges,
} from '@angular/fire/compat/database';

import {
  AngularFirestore,
  AngularFirestoreCollection,
  AngularFirestoreDocument,
} from '@angular/fire/compat/firestore';

import { Firestore, deleteDoc, doc, getFirestore } from 'firebase/firestore';
import { AngularFireStorage } from '@angular/fire/compat/storage';


@Injectable({
  providedIn: 'root',
})
export class CrudService {
  exerciseRef!: AngularFireObject<any>;
  exercises!: AngularFirestoreCollection<any>;
  private db: Firestore;

  constructor(public afs: AngularFirestore) { this.db = getFirestore(); }



  // Fetch Single exercise Object
  GetExercise(eid: string) {
    return this.afs.doc(`exercises/${eid}`).get();
  }


  // Fetch exercise List
  GetAllExercises() {
    return this.afs.collection("exercises").snapshotChanges();
  }



  async updateExerciseData( uid: string, exercise: Exercise) {
    const exerciseRef = this.afs.collection(`exercises/`);

    await exerciseRef.doc(uid).update({
      name: exercise.name,
      primaryGroup: exercise.primaryGroup,
      secondaryGroup: exercise.secondaryGroup,
      imgId: exercise.imgId,
      equipment: exercise.equipment,
      obs: exercise.obs
    })
  }

  SetExerciseData(eid: string, exercise: any) {
    const exerciseRef: AngularFirestoreDocument<any> = this.afs.doc(
      `exercises/${eid}`
    );

    const exerciseData: Exercise = {
      eid: eid,
      name: exercise.name,
      primaryGroup: exercise.primaryGroup,
      secondaryGroup: exercise.secondaryGroup,
      imgId: exercise.imgId,
      equipment: exercise.equipment,
      obs: exercise.obs
    };

    return exerciseRef.set(exerciseData, {
      merge: true,
    });
  }

  async deleteExercise(eid: string) {
    await deleteDoc(doc(this.db, 'exercises', eid));
  }
}