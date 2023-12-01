// build-elm.mjs
import { exec } from 'child_process';

exec('elm make src/Main.elm --output=main.js', (err, stdout, stderr) => {
  if (err) {
    console.error(`Elm compile error: ${err}`);
    return;
  }

  console.log(`stdout: ${stdout}`);
  console.error(`stderr: ${stderr}`);
});
