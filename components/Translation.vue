<template>
  <div>
      <b>{{ text }}</b>
      Under Construction
      <!-- <v-btn @click="converting('sample','sample0')" text>
        <span class="mr-2">Dylan</span>
      </v-btn>
      <v-btn @click="converting('sample0','sample0')" text>
        <span class="mr-2">Ariana</span>
      </v-btn>

      <div ref="parent">
        <convertedTemplete/>
      </div> -->

  </div>
</template>
<script>
var convertedTemplete = {
  template: '<div></div>'
}

export default {
  name: "Translation",
  components: {
    convertedTemplete
  },
  methods: {
    getConvertedText: async function() {
      try {
        const responseXML = await fetch('../assets/tei/'+this.xml+'.xml')
        const xml = new DOMParser().parseFromString(await responseXML.text(), 'text/xml')
        const responseXSL = await fetch('../assets/xslt/'+this.xsl+'.xsl')
        const xsl = new DOMParser().parseFromString(await responseXSL.text(), 'text/xml')
        var xsltProcessor = new XSLTProcessor()
        xsltProcessor.importStylesheet(xsl)
        var result = xsltProcessor.transformToDocument(xml).documentElement.outerHTML
        var isDark = ""
        if (this.$vuetify.theme.dark) {
          isDark = "dark"
        } else {
          isDark = "light"
        }
        convertedTemplete = {
          vuetify: new Vuetify({}),
          template: "<v-theme-provider " + isDark + ">" + result + "</v-theme-provider>"
        }
        //コンポーネントの再読み込み
        this.$refs["parent"].textContent = null;
        const ComponentClass = Vue.extend(convertedTemplete);
        const instance = new ComponentClass();
        instance.$mount();
        this.$refs["parent"].appendChild(instance.$el);

      } catch (err) {
        console.error(err)
      }
    },
    converting: function(xml,xsl) {
      this.xml = xml
      this.xsl = xsl
      this.getConvertedText()
    }
  },
  data: function() {
    return {
      xml: "sample",
      xsl: "sample0",
      text: 'Translation',
    }
  }
}
</script>
