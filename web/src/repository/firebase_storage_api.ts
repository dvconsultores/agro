import { FullMetadata, SettableMetadata, StorageError, UploadMetadata, UploadTask, UploadTaskSnapshot, ref as storageRef } from 'firebase/storage'
import { useFirebaseStorage, useStorageFile } from 'vuefire'
import * as vue_demi from 'vue-demi';

interface ReturnType {
  url: vue_demi.Ref<string | null | undefined>;
  metadata: vue_demi.ShallowRef<FullMetadata | null | undefined>;
  snapshot: vue_demi.ShallowRef<UploadTaskSnapshot | null | undefined>;
  uploadTask: vue_demi.ShallowRef<UploadTask | null | undefined>;
  uploadError: vue_demi.ShallowRef<StorageError | null | undefined>;
  uploadProgress: vue_demi.ComputedRef<number | null>;
  upload: (newData: Blob | Uint8Array | ArrayBuffer, newMetadata?: UploadMetadata) => Promise<unknown> | undefined;
  updateMetadata: (newMetadata: SettableMetadata) => Promise<FullMetadata | null>;
  refresh: () => Promise<[string | null, FullMetadata | null]>;
}

const _FILE_TYPES = {
  image: 'image',
  file: 'file'
}

type _FileType = keyof typeof _FILE_TYPES

export default class FirebaseStorageApi {
  private static _dirImages = "images";
  private static _dirFiles = "files";

  static upload(file: File, roomId: string, callback: (useStorage: ReturnType, fileType: _FileType) => {}) {
    const isImageType = /^image\//.test(file.type)
    const fileRef = storageRef(
      useFirebaseStorage(),
      `${isImageType ? this._dirImages : this._dirFiles}/${roomId}/${file.name}`
    )

    callback(useStorageFile(fileRef), isImageType ? 'image' : 'file')
  }
}
