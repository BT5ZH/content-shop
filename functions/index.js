const functions = require('firebase-functions');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const os = require('os');
const path = require('path');
const fs = require('fs');
const fbAdmin = require('firebase-admin');
const uuid = require('uuid/v4');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const gcconfig = {
    projectId: 'content-shop-8f405',
    keyFilename: 'cs-key.json'
};

const {Storage} = require('@google-cloud/storage');//(gcconfig);
const projectId='content-shop-8f405';
const storage=new Storage({
    projectId:projectId,
    keyFilename: 'cs-key.json'
});

fbAdmin.initializeApp({
    credential: fbAdmin.credential.cert(require('./cs-key.json'))
});

exports.storeImage = functions.https.onRequest((req, res) => {
    return cors(req, res, () => {
        if (req.method !== 'POST') {
            return res.status(500).json({ message: '非法请求' });
        }

        if (
            !req.headers.authorization || 
            !req.headers.authorization.startsWith('Bearer ')
            ) {
            return res.status(401).json({ error: '未经授权' });
        }

        let idToken;
        idToken = req.headers.authorization.split('Bearer ')[1];

        const busboy = new Busboy({ headers: req.headers });
        let uploadData;
        let oldImagePath;

        busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
            const filePath = path.join(os.tmpdir(), filename);
            uploadData = { filePath: filePath, type: mimetype, name: filename }
            file.pipe(fs.createWriteStream(filePath));
        });

        busboy.on('field', (fieldname, value) => {
            oldImagePath = decodeURIComponent(value);
        });

        busboy.on('finish', () => {
            const bucket = storage.bucket('content-shop-8f405.appspot.com');
            const id = uuid();
            let imagePath = 'images/' + id + '-' + uploadData.name;
            if (oldImagePath) {
                imagePath = oldImagePath;
            }

            return fbAdmin
                    .auth()
                    .verifyIdToken(idToken)
                    .then(decodedToken => {
                    return bucket.upload(uploadData.filePath, {
                        uploadType: 'media',
                        destination: imagePath,
                        metadata: {
                            metadata: {
                                contentType: uploadData.type,
                                firebaseStorageDownloadTokens: id
                            }
                        }
                    });
                }
            ).then(() => {
                return res.status(201).json({
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/' +
                        bucket.name +
                        '/o/' +
                        encodeURIComponent(imagePath) +
                        '?alt=media&token=' +
                        id,
                    imagePath: imagePath
                });
            })
                .catch(error => {
                    return res.status(401).json({ error: '未经授权！' })
                });
        });
        return busboy.end(req.rawBody);
    });
});

exports.deleteImage= functions.database.ref('contents/{contentId}').onDelete((snapshot)=>{
    const imageData=snapshot.val();
    const imagePath=imageData.imagePath;
    const bucket=storage.bucket('content-shop-8f405.appspot.com');
    return bucket.file(imagePath).delete();
});
