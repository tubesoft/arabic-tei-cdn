const {
  loadModule
} = window['vue2-sfc-loader'];
const options = {
  moduleCache: {
    vue: Vue
  },
  getFile(url) {
    return fetch(url).then(response => response.ok ? response.text() : Promise.reject(response));
  },
  addStyle(styleStr) {}
};
const routes = [
  // {
  //   path: '/',
  //   component: () => loadModule('./components/Home.vue', options)
  // },
  // {
  //   path: '/about',
  //   component: () => loadModule('./components/About.vue', options)
  // },
  // {
  //   path: '/edition',
  //   component: () => loadModule('./components/Edition.vue', options)
  // },
  // {
  //   path: '/translation',
  //   component: () => loadModule('./components/Translation.vue', options)
  // },
  // {
  //   path: '/parallel',
  //   component: () => loadModule('./components/Parallel.vue', options)
  // },
  // {
  //   path: '/glossary',
  //   component: () => loadModule('./components/Glossary.vue', options)
  // },
  {
    path: '/',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/"
    }
  },
  {
    path: '/about',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/about"
    }
  },
  {
    path: '/edition',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/edition"
    }
  },
  {
    path: '/translation',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/translation"
    }
  },
  {
    path: '/parallel',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/"
    }
  },
  {
    path: '/glossary',
    beforeEnter() {
      window.location = "https://tubesoft.github.io/arabic-tei/glossary"
    }
  },
];

const router = new VueRouter({
  routes
});

new Vue({
  el: '#app',
  router: router,
  vuetify: new Vuetify(
    {
      // These are props available
      // primary: '#1976D2',
      // secondary: '#424242',
      // accent: '#82B1FF',
      // error: '#FF5252',
      // info: '#2196F3',
      // success: '#4CAF50',
      // warning: '#FFC107',
    }
  ),
  computed: {
   setTheme() {
      if (this.goDark == true) {
        this.$vuetify.theme.dark = true;
        this.isON = "ON"
      } else {
        this.$vuetify.theme.dark = false;
        this.isON = "OFF"
      }
      if ('view' in this.$refs) {
        if ('xml' in this.$refs.view) {
          this.$refs.view.converting(this.$refs.view.xml, this.$refs.view.xsl)
        }
      }
    }
  },
  async created() {
    var num = 1
    try {
      while (true) {
        const responseXML = await fetch('assets/tei/AMI' + ( '00000' + num ).slice( -5 ) + '.xml')
        const xml = new DOMParser().parseFromString(await responseXML.text(), 'text/xml')
        const responseXSL = await fetch('assets/xslt/make-title-list.xsl')
        const xsl = new DOMParser().parseFromString(await responseXSL.text(), 'text/xml')
        var xsltProcessor = new XSLTProcessor()
        xsltProcessor.importStylesheet(xsl)
        var doc = xsltProcessor.transformToDocument(xml)
        var title = doc.getElementById('title').textContent
        var author = doc.getElementById('author').textContent
        var fileName = doc.getElementById('file-name').textContent
        var arrayItem = {'title': title, 'author': author, 'xml': fileName, 'xsl': 'tei-to-vue'}
        this.editionList.push(arrayItem)
        num++
      }
    } catch (e) {
      console.log("End of Data");
    } finally {
      this.render = true
    }
  },
  data: function() {
    return {
      goDark: window.matchMedia('(prefers-color-scheme: dark)').matches,
      isON: "",
      render: false,
      editionList: [],
    }
  },
});
